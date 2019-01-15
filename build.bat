@echo off  
 
echo start apk building.............  
 
D:\Unity\Editor\Unity.exe -quit -batchmode -executeMethod CityBuild.Build -logFile build.log
 
echo APK building success.............!  
pause 