@if (@CodeSection == @Batch) @then
@echo off & setlocal
setlocal EnableDelayedExpansion
title Njtech-Home Autologin Script

:: Check whether profile.json exist
if not exist .\assets\profile.json (
    echo profile.josn not exist, please rewrite it first at assets folder.
    echo. > .\assets\profile.json
    exit
)

:: Check whether WiFi is connected
call :CheckWiFiConnection isConnect
if %isConnect%==1 (
    echo WiFi is already connected, exit right now.
    exit
)

:: Check whether Njtech-Home WiFi exist
set "TargetSSID=Njtech-Home"
SET "isExist=0"
for /f "tokens=1,2,* delims=: " %%a in ('netsh wlan show networks mode^=bssid') do (
    if "%%a"=="SSID" set "SSID=%%c"
    if "!TargetSSID!"=="!SSID!" (
        set isExist=1
    )
)
if %isExist%==0 (
    echo Njtech-Home is not in range, exit right now.
    exit
)

:: Disable Manual proxy First
echo Disable manual proxy.
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f

:: Connect Njtech-Home Network
echo Connecting WiFi...
netsh wlan connect name="Njtech-Home" interface="WLAN" >nul 2>nul
call :WaitWiFiConnection

:: Check whether WiFi is connected
call :CheckWiFiConnection isConnect
if %isConnect%==1 (
    echo WiFi is already connected, exit right now.
    exit
)

::Run script
echo Running script...
.\assets\dist\autologin.exe

:: Check whether WiFi is connected
call :CheckWiFiConnection isConnect
if %isConnect%==1 (
    echo Connection succeeded.
) else (
    echo Connection failed, please try again manually.
    exit
)

:: Disconnect and then connect WiFi again
timeout 1 /nobreak >nul 2>nul
echo Disconnecting WiFi...
netsh wlan disconnect >nul 2>nul
:: echo beep sound effect
echo 
timeout 1 /nobreak >nul 2>nul
echo Connecting WiFi again...
netsh wlan connect name="Njtech-Home" interface="WLAN" >nul 2>nul

:: Read default browser from JSON file and kill it
for /f "Tokens=* Delims=" %%x in (.\assets\profile.json) do set JSON=!JSON!%%x
for /f "delims=" %%I in ('cscript /nologo /e:JScript "%~f0"') do set "%%~I"
taskkill /F /IM %JSON[browser]%.exe /T >nul 2>nul 

:: Exit script
echo All done, ready to exit.
exit

:: Functions

:CheckWiFiConnection
ping www.baidu.com -n 1 -w 1000 >nul 2>nul
if not errorlevel 1 ( SET %~1=1 ) else ( SET %~1=0 )
exit /b 0

:WaitWiFiConnection
:loop
ping u.njtech.edu.cn -n 1 -w 1000 >nul 2>nul
if errorlevel 1 ( goto loop )
exit /b 0

:: JScript JSON parser
@end // end Batch / begin JScript hybrid code
var htmlfile = WSH.CreateObject('htmlfile'),
    txt = WSH.CreateObject('Wscript.Shell').Environment('process').Item('JSON');
htmlfile.write('<meta http-equiv="x-ua-compatible" content="IE=9" />');
var obj = htmlfile.parentWindow.JSON.parse(txt);
htmlfile.close();
for (var i in obj) WSH.Echo('JSON[' + i + ']=' + obj[i]);
