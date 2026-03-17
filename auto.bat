@echo off

cd /d C:\Users\12455\Desktop\Blog

git add .

git diff --cached --quiet
if %errorlevel%==0 (
    echo No changes
) else (
    git commit -m "auto update"
    git push origin main
)

exit