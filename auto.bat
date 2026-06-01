@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 配置区域
set "REPO_PATH=C:\Users\Xioa\Desktop\Blog"
set "BRANCH=main"
set "DEEPSEEK_API_URL=https://api.deepseek.com/chat/completions"

title Git 自动同步工具 + DeepSeek AI
color 0B

:MAIN
cls
echo ========================================
echo   Git 博客自动同步系统 (DeepSeek AI)
echo ========================================
echo.
echo  目录: %REPO_PATH%
echo  分支: %BRANCH%
echo  时间: %date% %time%
echo.

:: 检查目录是否存在
if not exist "%REPO_PATH%" (
    color 0C
    echo [错误] 目标目录不存在
    pause
    exit
)

cd /d "%REPO_PATH%"

:: 检查并创建 .env 文件
call :CHECK_ENV

:: 检查 .gitignore 并添加 .env
call :CHECK_GITIGNORE

:: 检测文件变更
echo [扫描] 正在检测文件变更...
git add . 2>nul

git diff --cached --quiet
if !errorlevel! equ 0 (
    echo ========================================
    echo [完成] 没有检测到任何变更
    echo ========================================
    goto EXIT
)

:: 显示变更文件
echo.
echo [发现] 检测到以下文件变更:
git diff --cached --name-only
echo.

:: 用户确认
choice /c YNA /m "选择操作：[Y=AI生成提交, N=手动输入, A=取消]"
set "choice=!errorlevel!"

if !choice! equ 3 (
    echo [取消] 操作已取消
    goto EXIT
)

if !choice! equ 1 (
    :: AI生成commit信息
    call :AI_COMMIT
) else (
    :: 手动输入commit信息
    call :MANUAL_COMMIT
)

:: 执行推送
echo.
echo [执行] 正在推送到远程仓库...
git push origin %BRANCH%

if !errorlevel! equ 0 (
    color 0A
    echo.
    echo ========================================
    echo  成功！同步完成！
    echo  提交信息: !COMMIT_MSG!
    echo ========================================
) else (
    color 0C
    echo.
    echo ========================================
    echo  失败！请检查网络或Git配置
    echo ========================================
)

goto EXIT

:CHECK_ENV
if not exist ".env" (
    echo.
    echo [设置] 首次运行，需要配置DeepSeek API密钥
    echo 获取地址: https://platform.deepseek.com/api_keys
    echo.
    set /p "API_KEY=请输入DeepSeek API密钥: "
    
    (
        echo # DeepSeek API Configuration
        echo DEEPSEEK_API_KEY=!API_KEY!
        echo DEEPSEEK_MODEL=deepseek-chat
        echo DEEPSEEK_MAX_TOKENS=100
        echo DEEPSEEK_TEMPERATURE=0.7
    ) > .env
    
    echo.
    echo [完成] .env 文件已创建
    echo.
)

:: 读取.env文件
if exist ".env" (
    for /f "usebackq tokens=1,2 delims==" %%a in (".env") do (
        if not "%%a"=="# DeepSeek API Configuration" (
            set "%%a=%%b"
        )
    )
    
    if "!DEEPSEEK_API_KEY!"=="" (
        color 0C
        echo [错误] API密钥未配置
        echo 请在.env文件中设置 DEEPSEEK_API_KEY=你的密钥
        pause
        exit
    )
)
goto :EOF

:CHECK_GITIGNORE
if not exist ".gitignore" (
    echo .env > .gitignore
    echo [创建] .gitignore 已创建
) else (
    findstr /c:".env" .gitignore >nul 2>&1
    if !errorlevel! neq 0 (
        echo .env >> .gitignore
        echo [更新] .env 已添加到.gitignore
    )
)
goto :EOF

:AI_COMMIT
echo.
echo [AI] 正在使用DeepSeek分析变更内容...

:: 获取变更统计
for /f "tokens=1,2,3,4" %%a in ('git diff --cached --stat') do (
    set "CHANGED_FILES=%%a"
    set "INSERTIONS=%%c"
    set "DELETIONS=%%d"
)

:: 获取变更文件列表
set "FILE_LIST="
for /f "usebackq delims=" %%i in (`git diff --cached --name-only`) do (
    set "FILE_LIST=!FILE_LIST!%%i, "
)

:: 获取简短的变更摘要
set "DIFF_SUMMARY="
for /f "usebackq delims=" %%i in (`git diff --cached --stat`) do (
    set "DIFF_SUMMARY=!DIFF_SUMMARY!%%i; "
)

:: 构建请求JSON
set "REQUEST_JSON={"
set "REQUEST_JSON=!REQUEST_JSON!\"model\": \"!DEEPSEEK_MODEL!\","
set "REQUEST_JSON=!REQUEST_JSON!\"messages\": ["
set "REQUEST_JSON=!REQUEST_JSON!{\"role\": \"system\", \"content\": \"你是Git提交信息生成助手。根据文件变更生成简洁的中文commit信息。格式：类型: 描述。类型：feat新功能/fix修复/docs文档/style格式/refactor重构。不超过50字。\"},"
set "REQUEST_JSON=!REQUEST_JSON!{\"role\": \"user\", \"content\": \"变更文件: !FILE_LIST! 变更统计: !DIFF_SUMMARY! 请生成commit信息\"}"
set "REQUEST_JSON=!REQUEST_JSON!],"
set "REQUEST_JSON=!REQUEST_JSON!\"max_tokens\": !DEEPSEEK_MAX_TOKENS!,"
set "REQUEST_JSON=!REQUEST_JSON!\"temperature\": !DEEPSEEK_TEMPERATURE!"
set "REQUEST_JSON=!REQUEST_JSON!}"

:: 保存请求JSON到文件
echo !REQUEST_JSON! > "%TEMP%\request.json"

:: 调用DeepSeek API
echo [调试] API URL: !DEEPSEEK_API_URL!
echo [调试] 模型: !DEEPSEEK_MODEL!

curl -s -w "\n%%{http_code}" -X POST "!DEEPSEEK_API_URL!" ^
    -H "Content-Type: application/json" ^
    -H "Authorization: Bearer !DEEPSEEK_API_KEY!" ^
    -d "@%TEMP%\request.json" > "%TEMP%\response.txt" 2>&1

:: 解析响应
set "COMMIT_MSG="
set "HTTP_CODE="

if exist "%TEMP%\response.txt" (
    :: 提取HTTP状态码（最后一行）
    for /f "usebackq delims=" %%i in ("%TEMP%\response.txt") do set "HTTP_CODE=%%i"
    
    echo [调试] HTTP状态码: !HTTP_CODE!
    
    if "!HTTP_CODE!"=="200" (
        :: 提取content字段
        for /f "usebackq tokens=*" %%i in ("%TEMP%\response.txt") do (
            echo %%i | findstr /c:"\"content\"" >nul 2>&1
            if !errorlevel! equ 0 (
                set "line=%%i"
                set "COMMIT_MSG=!line:*content\": \"=!"
                set "COMMIT_MSG=!COMMIT_MSG:\"=!"
                set "COMMIT_MSG=!COMMIT_MSG:  = !"
            )
        )
    ) else (
        echo [错误] API调用失败，状态码: !HTTP_CODE!
        echo [调试] 完整响应:
        type "%TEMP%\response.txt"
    )
)

:: 清理临时文件
del "%TEMP%\request.json" 2>nul
del "%TEMP%\response.txt" 2>nul

:: 检查结果
if "!COMMIT_MSG!"=="" (
    echo.
    echo [警告] AI生成失败，可能的原因：
    echo 1. API密钥无效或过期
    echo 2. 网络连接问题
    echo 3. API地址错误
    echo.
    set "COMMIT_MSG=更新: !FILE_LIST:~0,-2!"
    echo [回退] 使用基于文件名的提交信息: !COMMIT_MSG!
) else (
    echo.
    echo [AI] 生成的提交信息: !COMMIT_MSG!
    echo.
    choice /c YNR /m "选择：[Y=使用, N=手动输入, R=重新生成]"
    
    if !errorlevel! equ 2 (
        call :MANUAL_COMMIT
        goto :EOF
    )
    if !errorlevel! equ 3 (
        goto AI_COMMIT
    )
)

:: 执行commit
echo.
echo [提交] 正在提交变更...
git commit -m "!COMMIT_MSG!"
echo [完成] 提交成功
goto :EOF

:MANUAL_COMMIT
echo.
echo 变更文件:
git diff --cached --name-only
echo.
set /p "COMMIT_MSG=请输入提交信息: "
if "!COMMIT_MSG!"=="" (
    for /f "usebackq delims=" %%i in (`git diff --cached --name-only`) do (
        set "COMMIT_MSG=更新: %%i"
        goto :COMMIT
    )
    set "COMMIT_MSG=更新: %date% %time%"
)
:COMMIT
git commit -m "!COMMIT_MSG!"
goto :EOF

:EXIT
echo.
echo ========================================
echo  按任意键退出...
pause >nul
exit