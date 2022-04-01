@echo off
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
setlocal EnableDelayedExpansion
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

:: Stop Microsoft Edge browser
echo Stop Microsoft Edge browser
taskkill /F /IM msedge.exe /T > >nul 2>nul

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
