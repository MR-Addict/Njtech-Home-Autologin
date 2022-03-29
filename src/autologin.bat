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

:: Connect Njtech-Home Network twice
netsh wlan connect name="Njtech-Home" interface="WLAN"
timeout 2 /nobreak > .\assets\echo.txt
netsh wlan connect name="Njtech-Home" interface="WLAN"
timeout 2 /nobreak > .\assets\echo.txt

::Run script
python .\assets\autologin.py

:: Disconnect and then connect WiFi network
netsh wlan disconnect
timeout 2 /nobreak > .\assets\echo.txt
netsh wlan connect name="Njtech-Home" interface="WLAN"
timeout 2 /nobreak > .\assets\echo.txt

:: Exit script
exit
