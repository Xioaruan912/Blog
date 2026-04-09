@echo off
setlocal enabledelayedexpansion

:: --- CONFIGURATION ---
set "REPO_PATH=C:\Users\Xioa\Desktop\Blog"
set "BRANCH=main"
set "TIME_STAMP=%DATE% %TIME%"

title Git Auto-Sync Tool
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

:: 1. Check Directory
if not exist "%REPO_PATH%" (
    color 0C
    echo [ERROR] Target directory not found. 
    echo Please check REPO_PATH in the script.
    pause
    exit
)

cd /d "%REPO_PATH%"

:: 2. Scan Changes
echo [*] Scanning for changes...
git add .

:: Check if there are staged changes
git diff --cached --quiet
if %errorlevel%==0 (
    color 0E
    echo ---------------------------------------------------------------------
    echo [DONE] Status: No changes detected.
    echo ---------------------------------------------------------------------
    goto FINAL_COUNTDOWN
)

:: 3. Interactive Confirmation
echo ---------------------------------------------------------------------
echo [!] Local changes detected.
echo [?] Sync to remote now?
echo.
choice /c YN /m ">> [Y] Push Changes, [N] Cancel: "

if %errorlevel% equ 2 (
    echo.
    echo [!] Operation cancelled by user.
    goto FINAL_COUNTDOWN
)

:: 4. Execution
echo.
echo [1/2] Creating commit...
git commit -m "Auto-update: %TIME_STAMP%"

echo [2/2] Pushing to remote [%BRANCH%]...
git push origin %BRANCH%

if %errorlevel% equ 0 (
    color 0A
    echo.
    echo =====================================================================
    echo SUCCESS: Sync Completed!
    echo =====================================================================
) else (
    color 0C
    echo.
    echo =====================================================================
    echo ERROR: Sync Failed. Please check network or git config.
    echo =====================================================================
)

:FINAL_COUNTDOWN
echo.
echo ---------------------------------------------------------------------
echo  System will exit in 3 seconds...
echo  Press [S] to STAY and view logs.
echo ---------------------------------------------------------------------

:: Countdown 3 seconds, default to Exit (T)
choice /c ST /t 3 /d T /n >nul

:: If user presses S (Stay)
if %errorlevel% equ 1 (
    color 0F
    echo [STAY] Auto-exit disabled. 
    echo Press any key to close this window manually.
    pause >nul
    exit
)

:: Else exit
cls
exit