@echo off
title Njtech-Home Network auto login script

echo Trying to auto connect...

:: Check profile.json whether exist
if not exist .\assets\profile.json (
    echo profile.josn not exist, please rewrite it first at assets folder.
    echo. > .\assets\profile.json
    pause
    exit
)

:: Disable Manual proxy First
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >

:: Connect Njtech-Home Network 
timeout 2 /nobreak > .\assets\echo.txt
netsh wlan connect name="Njtech-Home" interface="WLAN" > .\assets\echo.txt
timeout 2 /nobreak > .\assets\echo.txt

::Run script
python .\assets\autologin.py

:: Stop Microsoft Edge browser
taskkill /F /IM msedge.exe /T > echo.txt

:: Check WiFi connection
ping www.baidu.com -n 1 -w 1000 > .\assets\echo.txt

if errorlevel 1 (
    echo Connection failed, please try again.
) else (
    echo Connection success, ready to exit.
)

:: Disconnect and then connect WiFi network
timeout 2 /nobreak > .\assets\echo.txt
netsh wlan disconnect > .\assets\echo.txt
timeout 2 /nobreak > .\assets\echo.txt
netsh wlan connect name="Njtech-Home" interface="WLAN" > .\assets\echo.txt
timeout 2 /nobreak > .\assets\echo.txt

:: Exit script
exit
