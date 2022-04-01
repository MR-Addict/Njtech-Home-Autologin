@echo off
title Njtech-Home Autologin Guide Script

:: Change path to asssets folder
cd .\assets\

:: Set Njtech-Home connect manually
echo Set Njtech-Home connect manually.
netsh wlan set profileparameter name=Njtech-Home connectionmode=manual >nul 2>nul

:: Input profile information
set /p username=Input your username:
set /p password=Input your passwrod:
set /p provider=Input your provider:
echo {> .\profile.json
echo   "username":"%username%",>> .\profile.json
echo   "password":"%password%",>> .\profile.json
echo   "provider":"%provider%">> .\profile.json
echo }>> .\profile.json

:: Compile python file
WHERE python >nul 2>nul
if errorlevel 1 (
    echo You haven't install python yet, please install first.
    echo If you already have compiled python file, you can skip this step.
    echo Download link for windows is https://www.python.org/downloads/windows/
    pause
    exit
) else (
    echo Trying to install pyinstaller, please wait...
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f
    pip install -i https://mirrors.aliyun.com/pypi/simple/ pyinstaller >nul 2>nul

    echo Trying to compile python file, please wait...
    pyinstaller -F .\autologin.py >nul 2>nul
    echo Configuration all done, press enter to exit.
    pause >nul 2>nul
    exit
)
