@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 配置区域
set "REPO_PATH=C:\Users\Xioa\Desktop\Blog"
set "BRANCH=main"

title Git 自动同步工具
color 0B

:MAIN
cls
echo ========================================
echo        Git 博客内容自动同步系统
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
    echo 请检查脚本中的 REPO_PATH 配置
    pause
    exit
)

cd /d "%REPO_PATH%"

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

:: 用户确认
echo ========================================
echo.
choice /c YN /m "是否推送到远程仓库？[Y=是, N=否]"
if !errorlevel! equ 2 (
    echo [取消] 操作已取消
    goto EXIT
)

:: 执行推送
echo.
echo [执行] 正在提交变更...
git commit -m "自动更新: %date% %time%"

echo [执行] 正在推送到远程仓库...
git push origin %BRANCH%

if !errorlevel! equ 0 (
    color 0A
    echo.
    echo ========================================
    echo  成功！同步完成！
    echo ========================================
) else (
    color 0C
    echo.
    echo ========================================
    echo  失败！请检查网络或Git配置
    echo ========================================
)

:EXIT
echo.
echo ========================================
echo  按任意键退出...
pause >nul
exit