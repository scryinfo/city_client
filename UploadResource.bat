echo off

::工具目录

set scptool=D:\tools\winscp\

set local_dir=..\client\Assets\StreamingAssets\

set remote_dir= /home/cityrs/city1

::账号

set account=root

set password=djf0KJop9823u7j*

set host=40.73.5.184

set port=22

::切换到WinSCP软件目录

D:

cd %scptool%

::调用软件 执行上传

WinSCP.exe /console /command "option batch continue" "option confirm off" "open root:djf0KJop9823u7j*@40.73.5.184:22" "cd /home/cityrs/city1" "lcd G:\city_project\client\Assets\StreamingAssets\" "option transfer binary" "put G:\city_project\client\Assets\StreamingAssets\*.* /home/cityrs/city1 " "close" "exit"

echo upload completed.....

pause