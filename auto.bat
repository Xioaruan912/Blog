@echo off
chcp 936 >nul
setlocal enabledelayedexpansion

:: ===== 配置 =====
set "REPO_PATH=C:\Users\Xioa\Desktop\Blog"
set "BRANCH=main"
set "API_URL=https://api.deepseek.com/chat/completions"

title Git 自动同步 + DeepSeek AI
color 0B

:MAIN
cls
echo ========================================
echo     Git 博客自动同步 (DeepSeek AI)
echo ========================================
echo.
echo  目录: %REPO_PATH%
echo  分支: %BRANCH%
echo  时间: %date% %time%
echo.

:: 检查目录
if not exist "%REPO_PATH%" (
    color 0C
    echo [错误] 目录不存在
    pause
    exit
)
cd /d "%REPO_PATH%"

:: 初始化环境
call :INIT_ENV

:: 检查变更
echo [扫描] 正在检测文件变更...
git add . 2>nul
git diff --cached --quiet
if !errorlevel! equ 0 (
    echo [完成] 没有检测到任何变更
    goto EXIT
)

:: 显示变更
echo.
echo [发现] 变更的文件:
git diff --cached --name-only

:: 用户选择
echo.
choice /c YNA /m "请选择: [Y]AI生成提交信息 [N]手动输入 [A]取消"
set "opt=!errorlevel!"
if !opt! equ 3 goto EXIT

:: 生成提交信息
if !opt! equ 1 (
    call :AI_COMMIT
) else (
    call :MANUAL_COMMIT
)

:: 推送
echo.
echo [推送] 正在推送到远程仓库...
git push origin %BRANCH%
if !errorlevel! equ 0 (
    color 0A
    echo ========================================
    echo  成功! 同步完成
    echo  提交信息: !COMMIT_MSG!
    echo ========================================
) else (
    color 0C
    echo ========================================
    echo  失败! 请检查网络或 Git 配置
    echo ========================================
)
goto EXIT

:INIT_ENV
:: 首次运行创建 .env 模板
if not exist ".env" (
    echo [设置] 首次运行，请配置 DeepSeek API 密钥
    echo 获取地址: https://platform.deepseek.com/api_keys
    set /p "key=请输入密钥: "
    (
        echo DEEPSEEK_API_KEY=!key!
        echo DEEPSEEK_MODEL=deepseek-chat
    ) > .env
    echo [完成] .env 已创建
)
:: 读取 .env
for /f "usebackq tokens=1,2 delims==" %%a in (".env") do (
    if "%%a"=="DEEPSEEK_API_KEY" set "API_KEY=%%b"
    if "%%a"=="DEEPSEEK_MODEL" set "MODEL=%%b"
)
if "!API_KEY!"=="" (
    color 0C
    echo [错误] .env 中未配置 DEEPSEEK_API_KEY
    pause
    exit
)
:: 确保 .env 不会被提交
if not exist ".gitignore" (
    echo .env > .gitignore
) else (
    findstr /c:".env" .gitignore >nul 2>&1 || echo .env >> .gitignore
)
goto :EOF

:AI_COMMIT
echo.
echo [AI] 正在请求 DeepSeek 生成提交信息...

:: 获取变更摘要
set "files="
for /f "usebackq delims=" %%i in (`git diff --cached --name-only`) do (
    set "files=!files!%%i, "
)
if defined files set "files=!files:~0,-2!"

:: 构建请求 JSON
(
echo {
echo   "model": "!MODEL!",
echo   "messages": [
echo     {"role": "system", "content": "你是Git提交信息生成器。根据变更文件生成简洁的中文commit，格式：类型: 简短描述，不超过50字。类型包括feat新功能/fix修复/docs文档等。"},
echo     {"role": "user", "content": "变更文件: !files!。请生成commit信息。"}
echo   ],
echo   "max_tokens": 50,
echo   "temperature": 0.7
echo }
) > "%TEMP%\ai_req.json"

:: 调用 API
curl -s -X POST "!API_URL!" ^
    -H "Content-Type: application/json" ^
    -H "Authorization: Bearer !API_KEY!" ^
    -d "@%TEMP%\ai_req.json" > "%TEMP%\ai_resp.txt" 2>&1

:: 解析响应
set "COMMIT_MSG="
for /f "usebackq delims=" %%a in ("%TEMP%\ai_resp.txt") do (
    echo %%a | findstr /c:"\"content\"" >nul
    if !errorlevel! equ 0 (
        for /f "tokens=2 delims=:" %%b in ("%%a") do (
            set "COMMIT_MSG=%%b"
            set "COMMIT_MSG=!COMMIT_MSG:"=!"
            set "COMMIT_MSG=!COMMIT_MSG:  = !"
        )
    )
)
del "%TEMP%\ai_req.json" 2>nul
del "%TEMP%\ai_resp.txt" 2>nul

:: 处理结果
if "!COMMIT_MSG!"=="" (
    echo [警告] AI 生成失败，将使用默认信息
    set "COMMIT_MSG=自动更新: %date%"
) else (
    echo [AI] 生成的信息: !COMMIT_MSG!
    choice /c YNR /m "是否使用? [Y]是 [N]手动输入 [R]重新生成"
    if !errorlevel! equ 2 (
        call :MANUAL_COMMIT
        goto :EOF
    )
    if !errorlevel! equ 3 goto AI_COMMIT
)
git commit -m "!COMMIT_MSG!"
goto :EOF

:MANUAL_COMMIT
echo.
set /p "COMMIT_MSG=请输入提交信息: "
if "!COMMIT_MSG!"=="" set "COMMIT_MSG=手动更新: %date%"
git commit -m "!COMMIT_MSG!"
goto :EOF

:EXIT
echo.
echo 按任意键退出...
pause >nul
exit