@echo off 

set n = 0

:start_kill
timeout /T 2
start C:\usertools\DirectoryMonitor2_Portable\DirectoryMonitor.exe
timeout /T 10
taskkill /F /IM DirectoryMonitor.exe* /T

set /a n+=1
if %n% == 0 exit
echo.
echo %date%%time%
echo ==========  The %n%'th inspection was successfully  ==========
echo. 
echo.
goto start_kill
    