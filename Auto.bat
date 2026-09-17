@echo off
setlocal enabledelayedexpansion
chcp 936 >nul

:: ============================================================
::  博客仓库 · Git 自动同步工具
::  用法：把本文件放在仓库根目录，双击运行即可
:: ============================================================

:: -------------------- 配置区 --------------------
set "REPO_PATH=%~dp0"
set "BRANCH=main"
set "REMOTE=origin"
:: ------------------------------------------------

if "%REPO_PATH:~-1%"=="\" set "REPO_PATH=%REPO_PATH:~0,-1%"
title 博客仓库 · Git 自动同步
mode con cols=92 lines=34 >nul 2>nul

cd /d "%REPO_PATH%" 2>nul
if errorlevel 1 (
    color 0C
    echo.
    echo  [错误] 无法进入仓库目录：
    echo         %REPO_PATH%
    echo.
    pause
    exit /b 1
)

:MENU
cls
color 0B
call :HEADER

:: ---------- 环境检查 ----------
where git >nul 2>nul
if errorlevel 1 (
    color 0C
    echo  [错误] 未检测到 Git，请先安装并加入系统 PATH。
    echo         下载地址：https://git-scm.com/download/win
    goto :END
)

git rev-parse --is-inside-work-tree >nul 2>nul
if errorlevel 1 (
    color 0E
    echo  [警告] 当前目录不是有效的 Git 仓库：
    echo         %REPO_PATH%
    echo.
    echo  常见原因：.git 目录缺失或损坏，例如缺少 objects 子目录。
    echo.
    choice /c YN /m " 是否在此初始化仓库并关联远程【Y/N】" /t 30 /d N
    if !errorlevel! equ 2 goto :END
    call :INIT_REPO
    goto :MENU
)

:: ---------- 仓库信息 ----------
for /f "delims=" %%b in ('git rev-parse --abbrev-ref HEAD 2^>nul') do set "CUR_BRANCH=%%b"
set "CUR_REMOTE="
for /f "delims=" %%r in ('git remote get-url %REMOTE% 2^>nul') do set "CUR_REMOTE=%%r"

echo  [仓库] %REPO_PATH%
echo  [分支] !CUR_BRANCH!           [远程] %REMOTE% / %BRANCH%
if defined CUR_REMOTE (
    echo  [地址] !CUR_REMOTE!
) else (
    echo  [地址] 未配置远程 %REMOTE%
)
if /i not "!CUR_BRANCH!"=="%BRANCH%" (
    echo.
    echo  [提示] 当前分支为 !CUR_BRANCH!，与配置的同步分支 %BRANCH% 不一致。
)
echo.

:: ---------- 扫描改动 ----------
echo  [*] 正在扫描本地改动...
set "CHANGES=0"
for /f %%c in ('git status --porcelain ^| find /c /v ""') do set "CHANGES=%%c"

if "!CHANGES!"=="0" (
    color 0E
    echo.
    echo  ============================================================
    echo   [完成] 没有检测到任何改动，无需同步。
    echo  ============================================================
    goto :END
)

echo.
echo  ------------------------------------------------------------
echo   [发现] 共 !CHANGES! 处改动：
echo  ------------------------------------------------------------
git status --short
echo  ------------------------------------------------------------
echo.

:: ---------- 提交信息 ----------
for /f "usebackq delims=" %%t in (`powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-dd HH:mm'"`) do set "DEFAULT_MSG=Auto update: %%t"
echo   默认提交信息：!DEFAULT_MSG!
set "MSG="
set /p "MSG= 请输入提交信息【直接回车使用默认】: "
if not defined MSG set "MSG=!DEFAULT_MSG!"

echo.
choice /c YN /m " 确认提交并推送到 %REMOTE%/%BRANCH% 吗" /t 60 /d N
if !errorlevel! equ 2 (
    echo.
    echo  [取消] 已取消本次同步，未做任何改动。
    goto :END
)

:: ---------- 暂存与提交 ----------
echo.
echo  [1/3] 暂存并提交改动...
git add -A
> "%TEMP%\blog_commit_msg.txt" echo !MSG!
git commit -F "%TEMP%\blog_commit_msg.txt" >nul
set "COMMIT_RC=!errorlevel!"
del "%TEMP%\blog_commit_msg.txt" >nul 2>nul
if not "!COMMIT_RC!"=="0" (
    color 0C
    echo.
    echo  [失败] 提交失败，请查看上方 Git 输出。
    goto :END
)

:: ---------- 拉取远程更新 ----------
set "HAS_REMOTE=0"
if defined CUR_REMOTE for /f "delims=" %%x in ('git ls-remote --heads %REMOTE% %BRANCH% 2^>nul') do set "HAS_REMOTE=1"

if "!HAS_REMOTE!"=="1" (
    echo  [2/3] 拉取远程更新并变基...
    git pull --rebase %REMOTE% %BRANCH%
    if errorlevel 1 (
        color 0E
        echo.
        echo  [警告] 拉取或变基失败，可能存在冲突。
        echo         请手动处理【git status】后重新运行本脚本。
        goto :END
    )
) else (
    echo  [2/3] 远程暂无 %BRANCH% 分支，跳过拉取。
)

:: ---------- 推送 ----------
echo  [3/3] 推送到 %REMOTE%/%BRANCH% ...
git push -u %REMOTE% HEAD:%BRANCH%
if errorlevel 1 (
    color 0C
    echo.
    echo  ============================================================
    echo   [失败] 推送失败，请检查网络或远程仓库配置。
    echo  ============================================================
    goto :END
)

color 0A
echo.
echo  ============================================================
echo   [成功] 已同步到 %REMOTE%/%BRANCH%
echo   [信息] !MSG!
echo  ============================================================
goto :END


:: ============================================================
::  子过程
:: ============================================================
:HEADER
echo ============================================================
echo              博客仓库 · Git 自动同步工具
echo ============================================================
echo.
goto :eof

:INIT_REPO
echo.
set "INIT_URL="
set /p "INIT_URL= 请输入远程仓库地址【如 https://github.com/用户/仓库.git】: "
git init >nul
git branch -M %BRANCH% >nul 2>nul
if defined INIT_URL (
    git remote add %REMOTE% "!INIT_URL!" >nul 2>nul
    git remote set-url %REMOTE% "!INIT_URL!" >nul 2>nul
    echo  [完成] 已初始化本地仓库并关联远程：
    echo         !INIT_URL!
) else (
    echo  [完成] 已初始化本地仓库，未配置远程。
)
echo.
pause
goto :eof

:END
echo.
echo  ------------------------------------------------------------
echo   3 秒后自动关闭，按 S 键停留查看输出。
echo  ------------------------------------------------------------
choice /c ST /t 3 /d T /n >nul
if !errorlevel! equ 1 (
    color 0F
    echo  [停留] 请按任意键关闭窗口。
    pause >nul
    exit /b 0
)
cls
exit /b 0
