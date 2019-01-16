@echo off  

echo start gen wrap files.............  

D:\Unity\Editor\Unity.exe -quit -batchmode -executeMethod CityBuild._genWrapFiles -logFile build.log
 
echo gen wrap files finished.............!  

echo start apk building.............  
 
D:\Unity\Editor\Unity.exe -quit -batchmode -executeMethod CityBuild.Build -logFile build.log
 
echo apk building finished.............!  

echo start res building.............  
 
D:\Unity\Editor\Unity.exe -quit -batchmode -executeMethod CityBuild.BuildResourceBundle -logFile build.log
 
echo res building finished.............!  