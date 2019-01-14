@echo off  
 
echo 正在生成APK文件...  
 
D:\Software\Unity\Editor\Unity.exe -quit -batchmode -executeMethod CityBuild.Build -logFile build.log
 
echo APK文件生成完毕!  
pause 
