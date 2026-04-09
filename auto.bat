@echo off
:: 设置字符集为 UTF-8，解决中文乱码问题
chcp 65001 >nul
setlocal enabledelayedexpansion

:: --- 配置区域 ---
set "REPO_PATH=C:\Users\Xioa\Desktop\Blog"
set "BRANCH=main"
set "TIME_STAMP=%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,8%"

:: 窗口设置
title Blog Auto-Sync Tool
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

:: 1. 路径检测
if not exist "%REPO_PATH%" (
    color 0C
    echo [ERROR] 找不到指定的路径，请检查脚本中的 REPO_PATH 设置。
    pause
    exit
)

cd /d "%REPO_PATH%"

:: 2. 扫描变更
echo [*] 正在扫描文件变更...
git add .

:: 检查是否有待提交内容
git diff --cached --quiet
if %errorlevel%==0 (
    color 0E
    echo ---------------------------------------------------------------------
    echo [DONE] 状态: 没有任何变更需要同步。
    echo ---------------------------------------------------------------------
    timeout /t 5
    goto END
)

:: 3. 交互式确认
echo ---------------------------------------------------------------------
echo [!] 检测到本地代码仓存在更新。
set /p "choice=>> 是否立即同步到远程仓库? [Y/N]: "
if /I not "%choice%"=="Y" (
    echo [!] 操作已由用户取消。
    timeout /t 3
    goto END
)

:: 4. 执行提交与推送
echo.
echo [1/2] 正在创建本地提交...
git commit -m "Auto-update: %TIME_STAMP%"

echo [2/2] 正在推送到远程仓库 [%BRANCH%]...
git push origin %BRANCH%

if %errorlevel% equ 0 (
    color 0A
    echo.
    echo =====================================================================
    echo SUCCESS: 同步任务圆满完成！
    echo =====================================================================
) else (
    color 0C
    echo.
    echo =====================================================================
    echo ERROR: 推送失败！请检查网络、SSH Key 或远程仓库权限。
    echo =====================================================================
    pause
)

:END
echo.
echo 脚本将在 3 秒后自动关闭...
timeout /t 3 > nul
exit