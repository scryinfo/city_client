@echo off

@如果从git拉新项目，无法编译，执行本文件即可
if exist Assets\CityGame\Source\Generate (
	rd/s/q Assets\CityGame\Source\Generate
)
md Assets\CityGame\Source\Generate
XCOPY Source_Generate Assets\CityGame\Source\Generate /s/e/y/f

echo "copying files finished"
