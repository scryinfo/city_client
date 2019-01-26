@echo off  

echo start update resources to hot update directory   at  %time%.............  

if exist D:\hotUp\CityHotUp (
	rd/s/q D:\hotUp\CityHotUp
)
md D:\hotUp\CityHotUp

XCOPY ..\client\Assets\StreamingAssets  D:\hotUp\CityHotUp /s /e /k /h /g /c /r/y
echo hot update resources updating finished at  %time%.............  