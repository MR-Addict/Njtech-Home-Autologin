@echo off
title Njtech-Home Network auto login script

:: Check profile if exist
if not exist ./assets/profile.json (
    echo profile.josn not exist, please rewrite it first at assets folder.
    echo. > ./assets/profile.json
    pause
    exit
)

:: Connect Njtech-Home Network twice
netsh wlan connect name="Njtech-Home" interface="WLAN"
timeout 2 /nobreak > null
netsh wlan connect name="Njtech-Home" interface="WLAN"
timeout 2 /nobreak > null

::Run script
python .\assets\autologin.py

:: Ping baidu.com for checking connection
ping baidu.com

:: Disconnect and then connect WiFi network
netsh wlan disconnect
timeout 2 /nobreak > null
netsh wlan connect name="Njtech-Home" interface="WLAN"
timeout 2 /nobreak > null

exit
