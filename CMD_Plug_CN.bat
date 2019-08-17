
@echo off  
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" 
 
if '%errorlevel%' NEQ '0' (  
    goto UACPrompt  
) else ( goto gotAdmin )  
   
:UACPrompt  
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs" 
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs" 
    "%temp%\getadmin.vbs" 
    exit /B  
   
:gotAdmin  
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )  
    pushd "%CD%" 
    CD /D "%~dp0" 
 
:begin


@Echo Off
color 2e
Title  CMD

:begin
cls
Echo选择以下功能使用：
echo     【1】电脑重命名
echo     【2】获取系统信息
echo     【3】创建新用户
echo     【4】删除老用户
echo     【5】通过IP获取其用户名
echo     【6】映射
echo     【7】注册表
echo     【Q】退出
Set /P Choice= 【输入命令】
If not "%Choice%"=="" (
  If "%Choice%"=="1" goto rename
  If "%Choice%"=="2" goto systeminfo
  if "%Choice%"=="3" goto adduser
  if "%Choice%"=="4" goto deluser
  if "%Choice%"=="5" goto ipuser
  if "%Choice%"=="6" goto mapping
  if "%Choice%"=="7" goto regedit
  If "%Choice%"=="Q" goto quit
  If "%Choice%"=="q" goto quit
)
else(
  goto begin
)
:rename
set Name=%COMPUTERNAME%
:GetHostName
set /p Name=请输入新的机器名:
if %Name%==%COMPUTERNAME% goto GetHostName
reg add "HKLM\system\CurrentControlSet\services\tcpip\parameters" /v "NV Hostname" /d %Name% /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /v ComputerName /d %Name% /f
echo 机器名已修改，重启后生效！
set /p Res=是否重启机器[y/n]:
if /i %Res% ==y (
	shutdown -r -t 0
)
else(
	echo 请稍后重启，修改后的机器名才会生效！
)
pause>nul
goto begin


:systeminfo
md systeminfo
systeminfo  >> systeminfo\%computername%.txt
echo 输出系统信息到 systeminfo 文件夹
pause>nul
goto begin


:adduser
net user
set /p Choose=是否创建隐藏账户[y/n]:
if /i "%Choose%"=="y" (
	goto hide
)
else(
	goto show
)
:hide
set /p User=请输入用户名:
set /p Password=请输入用户名密码：
net user %User%$ %Password% /add
net localgroup administrators %User%$ /add
echo 隐藏用户创建成功！
"HKEY_LOCAL_MACHINE\SAM\SAM" [1 17] 
"HKEY_LOCAL_MACHINE\SAM\SAM\Domains" [1 17]
md reg
reg export "HKEY_LOCAL_MACHINE\SAM\SAM\Domains\Account\Users\Names\%User%$" reg\BA_%User%$.reg
reg export "HKEY_LOCAL_MACHINE\SAM\SAM\Domains\Account\Users\000003EA" reg\BB_.reg
reg export "HKEY_LOCAL_MACHINE\SAM\SAM\Domains\Account\Users\000001F4" reg\AA_1F4.reg
regedit
set /p Res=BB_修改是否成功[y/n]:
if /i %Res% ==y	(
  net user %User%$ /del
	reg import reg\BA_%User%$.reg
	reg import reg\BB_.reg
	net user %User%$
)
else(
  rmdir /s/q 222 reg
)
rmdir /s/q 222 reg
pause>nul
goto begin
:show
set /p User=请输入用户名:
set /p Password=请输入用户名密码：
net user %User% %Password% /add
net localgroup administrators %User% /add
echo 新用户创建成功！
pause>nul
goto begin


:deluser
net user
set /p Choose=是否删除隐藏账户[y/n]:
if /i "%Choose%"=="y" (
	goto hide
)
else(
	goto show
)
:hide
set /p User=请输入用户名:
net user %User%$ %Password% /del
echo 隐藏用户删除成功！
pause>nul
goto begin
:show
set /p User=请输入用户名:
net user %User% /del
echo 老用户删除成功！
pause>nul
goto begin


:ipuser
set /p Ip=请输入IP:
nbtstat -A %Ip%
pause>nul
goto begin


:mapping
set /p Ip=请输入IP查看共享网络:
net view \\%Ip%
set /p Mlocal=请输入本地盘符:
net use %Mlocal% \\%Ip%
pause>nul
goto begin


:regedit
regedit
pause>nul
goto begin


:quit
exit
pause>nul
goto begin



