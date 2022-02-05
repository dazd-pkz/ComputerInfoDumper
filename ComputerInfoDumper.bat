@echo off
mode con lines=18 cols=64
title CID - ComputerInfoDumper ^| github.com/dazd-pkz
echo Dumping Informations, Please wait...
for /f "skip=1delims=" %%a in ('wmic csproduct get uuid') do set "hwid=%%a"&goto hwid
:hwid
set hwid=%hwid:~0,36%
for /f %%a in ('powershell Invoke-RestMethod api.ipify.org') do set publicip=%%a > nul
if "%publicip%"=="%publicip:Commands=%" (goto :continue) else (set publicip=[40;31mCan't reach[40;37m& goto :continue)
:continue
ping 8.8.8.8 -n 1 -l 1 -f -4 > nul
if %errorlevel%==0 (set network=Online [40;32m)
if %errorlevel%==1 (set network=Offline [40;31m)
for /f "tokens=*" %%g in ('VER') do (set winver=%%g)
cls
echo Setting up...
chcp 65001 > nul
set datefortd=%time:~0,8% the %date%
:info
mode con lines=18 cols=64
cls
echo.
echo   [40;31mInformations:[40;37m
echo.
echo      [40;33mUsername:[40;37m %username%
echo      [40;33mComputer Name:[40;37m %computername%
echo      [40;33mWindows Version:[40;37m Windows %winver:~27,2%
echo      [40;33mDate ^& Time:[40;37m %date% ^| %time%
echo      [40;33mHWID:[40;37m %hwid%
echo      [40;33mPublic IP:[40;37m %publicip%
echo      [40;33mNetwork Status:[40;37m %network%●[40;37m
echo.
echo   [40;31m- Informations dumped at %datefortd%.[40;37m
echo.
echo  [40;35mWrite 'DUMP' to create a file that lists all the informations.
echo  If you write anything else, the program will exit.[40;37m
echo.
set /p q=^> 
if %q%==DUMP (goto :logfile) else if %q%==dump (goto :logfile) else if %q%==Dump (goto :logfile) else if %q%==dUMP (goto :logfile) else (exit)
:logfile
mode con lines=8 cols=74
cls
if not exist Dumped (
mkdir Dumped
)
set HMAC=%random:~1,4%%random:~1,4%
set TD-DATE=%date:~0,2%%date:~3,2%%date:~6,2%
set UniqueID=%HMAC%-%TD-DATE%
if "%publicip%"=="%publicip:Can=%" (echo github.com/dazd-pkz > nul) else (set publicip=Can't reach)
echo Informations dumped at %datefortd% > Dumped\CIDLOG%UniqueID%.log
echo. >> Dumped\CIDLOG%UniqueID%.log
echo   - Username = %username% >> Dumped\CIDLOG%UniqueID%.log
echo   - Computer Name = %computername% >> Dumped\CIDLOG%UniqueID%.log
echo   - Windows Version = Windows %winver:~27,2% >> Dumped\CIDLOG%UniqueID%.log
echo   - Date ^& Time = %date% ^| %time% >> Dumped\CIDLOG%UniqueID%.log
echo   - HWID = %hwid% >> Dumped\CIDLOG%UniqueID%.log
echo   - Public IP = %publicip% >> Dumped\CIDLOG%UniqueID%.log
echo   - Network Status = %network:~0,7%>> Dumped\CIDLOG%UniqueID%.log
echo.>> Dumped\CIDLOG%UniqueID%.log
if "%publicip%"=="%publicip:Can=%" else (set publicip=[40;31mCan't reach[40;37m)
echo Informations Dumped with ComputerInfoDumper by github.com/dazd-pkz>> Dumped\CIDLOG%UniqueID%.log
echo.
echo   Informations dumped in 'Dumped\CIDLOG%UniqueID%.log'
echo.
echo    [40;35mWrite 'OPEN' to open the log file that lists all the informations.
echo    If you write anything else, you will return to the informations list.[40;37m
echo.
set /p q=^> 
if %q%==OPEN (goto :open) else if %q%==open (goto :open) else if %q%==Open (goto :open) else if %q%==oPEN (goto :open) else (goto :info)
:open
cls
start notepad Dumped\CIDLOG%UniqueID%.log
if %errorlevel%==1 (cls & echo Whoops! Said nothing bro lmao x^))
timeout 1 > nul /nobreak
goto :info