@echo off
title Njtech-Home Autologin Guide Script

:: Input profile information
set /p username=Input your username:
set /p password=Input your passwrod:
set /p provider=Input your provider:
set /p browser=Input your default browser:
echo {> .\profile.json
echo   "username": "%username%",>> .\profile.json
echo   "password": "%password%",>> .\profile.json
echo   "provider": "%provider%",>> .\profile.json
echo   "browser": "%browser%">> .\profile.json
echo }>> .\profile.json
