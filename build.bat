@echo off  

echo start gen wrap files  at  %time%.............  

D:\Unity\Editor\Unity.exe -quit -batchmode -executeMethod CityBuild._genWrapFiles -logFile build.log
 
echo gen wrap files finished  at  %time%.............!  

echo start apk building  at  %time%.............  
 
D:\Unity\Editor\Unity.exe -quit -batchmode -executeMethod CityBuild.Build -logFile build.log
 
echo apk building finished  at  %time%.............!  

echo start res building  at  %time%.............  
 
D:\Unity\Editor\Unity.exe -quit -batchmode -executeMethod CityBuild.BuildResourceBundle -logFile build.log

echo res building finished  at  %time%.............!  


echo start update resources to hot update directory   at  %time%.............  

if exist D:\hotUp\CityHotUp (
	rd/s/q D:\hotUp\CityHotUp
)
md D:\hotUp\CityHotUp

XCOPY ..\client\Assets\StreamingAssets  D:\hotUp\CityHotUp /s /e /k /h /g /c /r/y

XCOPY ..\client\Apk  D:\city_project\apk /s /e /k /h /g /c /r/y
rd/s/q ..\client\Apk

echo hot update resources updating finished at  %time%.............  