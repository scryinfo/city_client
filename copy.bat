@echo off

echo %cd%
cd %cd%\cityGitSvn
echo %cd%
echo "start copying files......"

if not exist ../client (
	echo "not exist,create the directory"
	md ..\client
)

if exist ../client (
	XCOPY ..\cityGitSub ..\client /s/e/d/y
	XCOPY *.* ..\client /s/e/d/y/EXCLUDE:Exclude.txt	
) else (
echo "directory not exist!"
)

rd/s/q ../client/Assets/CityGame/Source/Generate

if not exist ../client/Assets/CityGame/Source/Generate (
	md ..\client\Assets\CityGame\Source\Generate	
)
XCOPY Source_Generate ..\client\Assets\CityGame\Source\Generate /s/e/y

cd../proto25
client_Pb2Lua.bat


echo "copying files finished"
