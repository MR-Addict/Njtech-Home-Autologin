@echo off
title Njtech-Home Network auto login script

:: Check profile.json whether exist
if not exist .\assets\profile.json (
    echo profile.josn not exist, please rewrite it first at assets folder.
    echo. > .\assets\profile.json
    goto end
)

:: Check WiFi connection
ping www.baidu.com -n 1 -w 1000 > .\assets\echo.txt
if not errorlevel 1 (
    echo WiFi alrady connected, exit right now.
    goto end
)

:: Check whether WiFi exist
setlocal EnableDelayedExpansion
set "TargetSSID=Njtech-Home"
SET "count=0"
for /f "tokens=1,2,* delims=: " %%a in ('netsh wlan show networks mode^=bssid') do (
    if "%%a"=="SSID" set "SSID=%%c"
    if "!TargetSSID!"=="!SSID!" (
        set count=1
    )
)
if %count%==0 (
    echo Njtech-Home network not in range, exit right now.
    goto end
)

:: Disable Manual proxy First
echo Disable manual proxy.
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f

:: Connect Njtech-Home Network
echo Connecting WiFi...
netsh wlan connect name="Njtech-Home" interface="WLAN" > .\assets\echo.txt
timeout 5 /nobreak > .\assets\echo.txt

:: Check WiFi connection
ping www.baidu.com -n 1 -w 1000 > .\assets\echo.txt
if not errorlevel 1 (
    echo WiFi alrady connected, exit right now.
    goto end
)

::Run script
echo Running script...
.\assets\dist\autologin.exe

:: Check WiFi connection
ping www.baidu.com -n 1 -w 1000 > .\assets\echo.txt
if errorlevel 1 (
    echo Connection failed, please try again.
    goto end
) else (
    echo Connection succeeded.
)

:: Disconnect and then connect WiFi again
timeout 2 /nobreak > .\assets\echo.txt
echo Disconnecting WiFi...
netsh wlan disconnect > .\assets\echo.txt
timeout 2 /nobreak > .\assets\echo.txt
echo Connecting WiFi again...
netsh wlan connect name="Njtech-Home" interface="WLAN" > .\assets\echo.txt

:end
:: Stop Microsoft Edge browser
taskkill /F /IM msedge.exe /T > .\assets\echo.txt

:: Exit script
echo All done, ready to exit.
exit
