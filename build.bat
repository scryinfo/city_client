@echo off  

echo start gen wrap files  at  %time%.............  

D:\Unity\Editor\Unity.exe -quit -batchmode -executeMethod CityBuild._genWrapFiles -logFile build.log
 
echo gen wrap files finished  at  %time%.............!  

echo start apk building  at  %time%.............  
 
D:\Unity\Editor\Unity.exe -quit -batchmode -executeMethod CityBuild.Build -logFile build.log
 
echo apk building finished  at  %time%.............!  

echo start res building  at  %time%.............  
 
D:\Unity\Editor\Unity.exe -quit -batchmode -executeMethod CityBuild.BuildResourceBundle -logFile build.log
 
XCOPY ..\client\Assets\CityGame\Source\Generate  D:\CityHotUp1 /s/e/y

echo res building finished  at  %time%.............!  