@echo off
setlocal enabledelayedexpansion

:: 1. 强制声明代码页
chcp 65001 >nul

:: --- 基础配置 ---
set "REPO_PATH=C:\Users\Xioa\Desktop\Blog"
set "BRANCH=main"
set "TIME_STAMP=%DATE% %TIME%"

title Blog Sync Tool
mode con cols=85 lines=25
color 0B

:START
cls
echo =====================================================================
echo              GIT BLOG CONTENT AUTO-SYNC SYSTEM
echo =====================================================================
echo.
echo  [Directory] : %REPO_PATH%
echo  [Timestamp] : %TIME_STAMP%
echo.

if not exist "%REPO_PATH%" (
    color 0C
    echo [ERROR] Invalid Path.
    pause
    exit
)

cd /d "%REPO_PATH%"

echo [*] Scanning for changes...
git add .

git diff --cached --quiet
if %errorlevel%==0 (
    color 0E
    echo ---------------------------------------------------------------------
    echo [STATUS] No changes detected.
    echo ---------------------------------------------------------------------
    goto FINAL_COUNTDOWN
)

echo ---------------------------------------------------------------------
echo [!] Local changes detected.
echo [?] Sync to remote now?
echo.
choice /c YN /m ">> [Y] Push, [N] Cancel: "

if %errorlevel% equ 2 (
    echo [!] Cancelled.
    goto FINAL_COUNTDOWN
)

echo.
echo [1/2] Commit...
git commit -m "Auto-update: %TIME_STAMP%"
echo [2/2] Push...
git push origin %BRANCH%

if %errorlevel% equ 0 (
    color 0A
    echo.
    echo =====================================================================
    echo SUCCESS: Sync Completed.
    echo =====================================================================
) else (
    color 0C
    echo =====================================================================
    echo ERROR: Sync Failed.
    echo =====================================================================
)

:FINAL_COUNTDOWN
echo.
echo ---------------------------------------------------------------------
echo  System will exit in 3 seconds.
echo  Press [S] to STAY and view logs.
echo ---------------------------------------------------------------------

:: 核心：倒计时 3 秒，默认执行退出 (T)
choice /c ST /t 3 /d T /n >nul

:: 用户按了 S (Stay)
if %errorlevel% equ 1 (
    color 0F
    echo [OK] Auto-exit disabled.
    echo Press any key to close the window.
    pause >nul
    exit
)

:: 否则执行退出
cls
exit