@echo off
:: 强制开启 UTF-8 支持中文显示
chcp 65001 >nul
setlocal enabledelayedexpansion

:: --- 配置区域 ---
set "REPO_PATH=C:\Users\Xioa\Desktop\Blog"
set "BRANCH=main"
set "TIME_STAMP=%DATE% %TIME%"

title Blog Auto-Sync Tool (Modern Edition)
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
    echo [ERROR] 找不到指定的路径，请检查脚本配置。
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
    goto FINAL_COUNTDOWN
)

:: 3. 交互式确认 (使用 Choice 避免乱码报错)
echo ---------------------------------------------------------------------
echo [!] 检测到本地代码仓存在更新。
echo [?] 是否立即同步到远程仓库?
choice /c YN /m ">> [Y]确认同步, [N]取消操作: "

if %errorlevel% equ 2 (
    echo.
    echo [!] 操作已由用户取消。
    goto FINAL_COUNTDOWN
)

:: 4. 执行提交与推送
echo.
echo [1/2] 正在创建提交...
git commit -m "Auto-update: %TIME_STAMP%"

echo [2/2] 正在推送至远程 [%BRANCH%]...
git push origin %BRANCH%

if %errorlevel% equ 0 (
    color 0A
    echo.
    echo =====================================================================
    echo SUCCESS: 同步完成！
    echo =====================================================================
) else (
    color 0C
    echo.
    echo =====================================================================
    echo ERROR: 推送失败，请检查网络或权限。
    echo =====================================================================
)

:FINAL_COUNTDOWN
echo.
echo ---------------------------------------------------------------------
echo [*] 脚本任务结束。
echo [!] 提示：将在 3 秒后自动关闭。
echo [?] 如果需要查看日志，请在 3 秒内按 [S] 键停止关闭。
echo ---------------------------------------------------------------------

:: 使用 choice 设置 3 秒超时，默认执行退出 (T)，按 S 键拦截
choice /c ST /t 3 /d T /n >nul

:: 如果用户按了 S (errorlevel 1)
if %errorlevel% equ 1 (
    color 0F
    echo [OK] 自动关闭已取消。现在你可以自由查看控制台输出。
    echo 输入任意内容或直接关闭窗口即可。
    pause
    exit
)

:: 如果超时或用户按了 T (errorlevel 2)，直接清屏退出
cls
exit