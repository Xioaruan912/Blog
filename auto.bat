@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 配置区域
set "REPO_PATH=C:\Users\Xioa\Desktop\Blog"
set "BRANCH=main"
set "DEEPSEEK_API_URL=https://api.deepseek.com/v1/chat/completions"

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

:: 获取变更内容
git diff --cached > "%TEMP%\git_diff_temp.txt"

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

del "%TEMP%\git_diff_temp.txt" 2>nul
goto EXIT

:CHECK_ENV
if not exist ".env" (
    echo.
    echo [设置] 首次运行，需要配置DeepSeek API密钥
    echo.
    set /p "API_KEY=请输入DeepSeek API密钥: "
    
    echo # DeepSeek API Configuration > .env
    echo DEEPSEEK_API_KEY=!API_KEY! >> .env
    echo DEEPSEEK_MODEL=deepseek-chat >> .env
    echo DEEPSEEK_MAX_TOKENS=100 >> .env
    echo DEEPSEEK_TEMPERATURE=0.7 >> .env
    
    echo.
    echo [完成] .env 文件已创建
    echo.
)

:: 读取.env文件
if exist ".env" (
    for /f "tokens=1,2 delims==" %%a in (.env) do (
        set "%%a=%%b"
    )
    
    if "!DEEPSEEK_API_KEY!"=="" (
        color 0C
        echo [错误] API密钥未配置，请在.env文件中设置 DEEPSEEK_API_KEY
        echo 当前.env文件内容:
        type .env
        pause
        exit
    )
)
goto :EOF

:CHECK_GITIGNORE
if not exist ".gitignore" (
    echo # Git忽略文件 > .gitignore
    echo .env >> .gitignore
    echo [完成] .gitignore 已创建，.env已添加
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

:: 构建JSON请求体
set "DIFF_CONTENT="
for /f "usebackq delims=" %%i in ("%TEMP%\git_diff_temp.txt") do (
    set "line=%%i"
    set "line=!line:\=\\!"
    set "line=!line:"=\"!"
    set "DIFF_CONTENT=!DIFF_CONTENT!!line!\n"
)

:: 创建临时JSON文件
echo { > "%TEMP%\deepseek_request.json"
echo   "model": "!DEEPSEEK_MODEL!", >> "%TEMP%\deepseek_request.json"
echo   "messages": [ >> "%TEMP%\deepseek_request.json"
echo     { >> "%TEMP%\deepseek_request.json"
echo       "role": "system", >> "%TEMP%\deepseek_request.json"
echo       "content": "你是一个Git提交信息生成助手。根据git diff内容，生成简洁的中文commit信息。格式：类型: 简短描述。类型包括：feat(新功能)、fix(修复)、docs(文档)、style(格式)、refactor(重构)、test(测试)、chore(构建)。不超过50字。" >> "%TEMP%\deepseek_request.json"
echo     }, >> "%TEMP%\deepseek_request.json"
echo     { >> "%TEMP%\deepseek_request.json"
echo       "role": "user", >> "%TEMP%\deepseek_request.json"
echo       "content": "请为以下git变更生成commit信息：\n!DIFF_CONTENT!" >> "%TEMP%\deepseek_request.json"
echo     } >> "%TEMP%\deepseek_request.json"
echo   ], >> "%TEMP%\deepseek_request.json"
echo   "max_tokens": !DEEPSEEK_MAX_TOKENS!, >> "%TEMP%\deepseek_request.json"
echo   "temperature": !DEEPSEEK_TEMPERATURE! >> "%TEMP%\deepseek_request.json"
echo } >> "%TEMP%\deepseek_request.json"

:: 调用DeepSeek API
curl -s -X POST "!DEEPSEEK_API_URL!" ^
    -H "Content-Type: application/json" ^
    -H "Authorization: Bearer !DEEPSEEK_API_KEY!" ^
    -d "@%TEMP%\deepseek_request.json" > "%TEMP%\deepseek_response.json" 2>nul

:: 解析响应获取commit信息
if exist "%TEMP%\deepseek_response.json" (
    :: 使用简单的文本处理提取内容
    for /f "tokens=*" %%i in ('type "%TEMP%\deepseek_response.json" ^| findstr /c:"\"content\""') do (
        set "response=%%i"
    )
    
    if "!response!"=="" (
        echo [警告] AI生成失败，使用默认提交信息
        set "COMMIT_MSG=自动更新: %date% %time%"
    ) else (
        :: 清理响应内容
        set "COMMIT_MSG=!response:*content\": =!"
        set "COMMIT_MSG=!COMMIT_MSG:"=!"
        set "COMMIT_MSG=!COMMIT_MSG:  = !"
    )
) else (
    set "COMMIT_MSG=自动更新: %date% %time%"
)

echo [AI] 生成的提交信息: !COMMIT_MSG!
echo.
choice /c YN /m "是否使用此提交信息？[Y=是, N=重新生成]"

if !errorlevel! equ 2 (
    del "%TEMP%\deepseek_request.json" 2>nul
    del "%TEMP%\deepseek_response.json" 2>nul
    goto AI_COMMIT
)

:: 执行commit
git commit -m "!COMMIT_MSG!"
del "%TEMP%\deepseek_request.json" 2>nul
del "%TEMP%\deepseek_response.json" 2>nul
goto :EOF

:MANUAL_COMMIT
echo.
set /p "COMMIT_MSG=请输入提交信息: "
if "!COMMIT_MSG!"=="" (
    set "COMMIT_MSG=手动更新: %date% %time%"
)
git commit -m "!COMMIT_MSG!"
goto :EOF

:EXIT
echo.
echo ========================================
echo  按任意键退出...
pause >nul
exit