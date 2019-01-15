@echo off
@title 批处理拷贝文件
echo %cd%
if exist ../cityGit (
   XCOPY ..\cityGit /s/e/d/y/EXCLUDE:Exclude.txt
) else (
echo "文件夹不存在"
)
pause 