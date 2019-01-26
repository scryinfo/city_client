echo off

::工具目录

set scptool=D:\tools\winscp\

set local_dir=..\client\Assets\StreamingAssets

set remote_dir= /home/cityrs/city

::账号

set account=city

set password=djf0KJop9823u7j*

set host=40.73.5.184

set port=22

::切换到WinSCP软件目录

D:

cd %scptool%

::调用软件 执行上传

call WinSCP.exe /console /command "option batch continue" "option confirm off" "open %account%:%password%@%host%:%port%" "cd %remote_dir%" "lcd %local_dir%" "option transfer binary" "put -filemask=|*git/;*svn/;*META-INF/;*WEB-INF/;*csv/;*idea/;*DS_Store/;*hg/;*.bat;*.gitignore;*.iml;*settings/;*project/;*.hprof;*.pyc;*.bat %local_dir%*.* %remote_dir% " "close" "exit"

echo upload completed.....

pause