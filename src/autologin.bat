@echo off
title Njtech-Home Autologin Script

:: Check profile.json whether exist
if not exist .\assets\profile.json (
    echo profile.josn not exist, please rewrite it first at assets folder.
    echo. > .\assets\profile.json
    exit
)

:: Check whether WiFi is connected
call :CheckWiFiConnection isConnect
if %isConnect%==1 (
    echo WiFi already connected, exit right now.
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
    echo Njtech-Home not in range, exit right now.
    exit
)

:: Disable Manual proxy First
echo Disable manual proxy.
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f

:: Connect Njtech-Home Network
echo Connecting WiFi...
netsh wlan connect name="Njtech-Home" interface="WLAN" > .\assets\echo.txt
call :WaitWiFiConnection

:: Check whether WiFi is connected
call :CheckWiFiConnection isConnect
if %isConnect%==1 (
    echo WiFi alrady connected, exit right now.
    exit
)

:: Stop Microsoft Edge browser
echo Exit redirectting browser...
taskkill /F /IM msedge.exe /T > .\assets\echo.txt

::Run script
echo Running script...
.\assets\dist\autologin.exe

:: Check whether WiFi is connected
call :CheckWiFiConnection isConnect
if %isConnect%==1 (
    echo Connection succeeded.
) else (
    echo Connection failed, please try again.
    exit
)

:: Disconnect and then connect WiFi again
timeout 1 /nobreak > .\assets\echo.txt
echo Disconnecting WiFi...
netsh wlan disconnect > .\assets\echo.txt
timeout 1 /nobreak > .\assets\echo.txt
echo Connecting WiFi again...
netsh wlan connect name="Njtech-Home" interface="WLAN" > .\assets\echo.txt

:: Exit script
echo All done, ready to exit.
exit

:: Functions

:CheckWiFiConnection
ping u.njtech.edu.cn -n 1 -w 1000 > .\assets\echo.txt
if not errorlevel 1 (
    SET %~1=1
) else (
    SET %~1=0
)
exit /b 0

:WaitWiFiConnection
:while
call :CheckWiFiConnection isConnect
if %isConnect%==0 goto while
exit /b 0
