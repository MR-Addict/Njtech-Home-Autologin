# 0. Hide global progress bar
$progressPreference = "silentlyContinue"

function checkWiFiConnection($networkName) {
    cmd /c "ping $networkName -n 1 -w 1000 >nul 2>nul"
    if ($LASTEXITCODE) {
        return $false
    }
    else {
        return $true
    }
}

function isNjtechExist {
    netsh wlan show networks | ForEach-Object {
        if ($_ -match '^SSID (\d+) : (.*)$') {
            if ($matches[2].trim() -ceq "Njtech-Home") {
                return $true
            }
        }
    }
    return $false
}

function startProcess {
    # Start QQ and Clash
    # $Processes = (Get-Process).ProcessName
    # if ($Processes -notcontains "QQ") {
    #     Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Starting QQ..."
    #     Start-Process -FilePath "QQ" -RedirectStandardError Out-Null
    # }
    # if ($Processes -notcontains "Clash for Windows") {
    #     Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Starting Clash For Windows..."
    #     Start-Process -FilePath "Clash for Windows" -RedirectStandardError Out-Null
    # }
    # if ($Processes -notcontains "telegram") {
    #     Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Starting Telegram..."
    #     Telegram -startintray
    # }
}

# 1. Check profile file
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Loading login profile..."
if (!(Test-Path -Path $PSScriptRoot\profile.json)) {
    Write-Host "[ERROR] " -ForegroundColor Red -NoNewline; Write-Host "Login profile not exist, exit right now."
    Exit
}

# 2. Add Proxy Exception
$ProxyProperty = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
if ( $ProxyProperty.ProxyEnable -and $ProxyProperty.ProxyOverride -notmatch "njtech.edu.cn") {
    Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Adding proxy exception..."
    $ProxyExceptionList = "*njtech.edu.cn;" + $ProxyProperty.ProxyOverride
    $ProxyProperty | Set-ItemProperty -Name "ProxyOverride" -Value $ProxyExceptionList
}

# 3. Check WiFi Connection
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Checking whether you are connected..."
if (checkWiFiConnection("baidu.com")) {
    Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "WiFi already connected, exit right now."
    startProcess
    Exit
}

# 4. Check whether Njtech-Home exists
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Checking whether Njtech-Home available..."
if (!(isNjtechExist)) {
    Write-Host "[ERROR] " -ForegroundColor Red -NoNewline; Write-Host "Njtech-Home not available, exit right now."
    Exit
}

# 5. Connect Njtech-Home
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Checking Njtech-Home network..."
netsh wlan connect name="Njtech-Home" interface="WLAN" | Out-Null
while (!(checkWiFiConnection("u.njtech.edu.cn"))) {}

# 6. Check WiFi Connection
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Checking whether you are connected..."
if (checkWiFiConnection("baidu.com")) {
    Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "WiFi already connected, exit right now."
    startProcess
    Exit
}

# 7. Post data to remote host
# 7.1 Load profile information
$MyProfile = Get-Content $PSScriptRoot\profile.json -Raw | ConvertFrom-Json
# 7.2 Provider hash table and user agent
$provider = @{"cmcc" = "中国移动"; "telecom" = "中国电信" }
$UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.124 Safari/537.36 Edg/102.0.1245.41"
# 7.3 Get and post URL
$geturl = "https://i.njtech.edu.cn"
$posturl = "https://u.njtech.edu.cn"
$captchaapiurl = "http://202.119.245.12:45547"
# 7.4 Send post data
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Sending your profile to host..."
$r = Invoke-WebRequest -Uri $geturl -SessionVariable Session -UserAgent $UserAgent
Invoke-WebRequest -Uri " https://u.njtech.edu.cn/cas/captcha.jpg" -WebSession $Session -OutFile captcha.jpg
$form = $r.Forms[0]
$form.Fields["username"] = $MyProfile.username
$form.Fields["password"] = $MyProfile.password
$form.Fields["channelshow"] = $provider[$MyProfile.provider]
$form.Fields["channel"] = '@' + $MyProfile.provider
$form.Fields["captcha"] = (cmd /c "curl -skL $captchaapiurl -F captcha=@captcha.jpg" | ConvertFrom-Json).message
Remove-Item captcha.jpg

$posturl = $posturl + $form.Action
$r = Invoke-WebRequest -Uri $posturl -WebSession $Session -Method Post -Body $form -UserAgent $UserAgent
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Data Sending finished."

# 8. Check WiFi Connection
Start-Sleep -Seconds 1
if (checkWiFiConnection("baidu.com")) {
    Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "WiFi connected successfully."
}
else {
    Write-Host "[ERROR] " -ForegroundColor Red -NoNewline; Write-Host "WiFi connected failed, exit right now."
    Exit
}

# 9. Disconnect and connect WiFi
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Disconnecting WiFi..."
Start-Sleep -Seconds 1
netsh wlan disconnect | Out-Null
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Connecting WiFi again..."
Start-Sleep -Seconds 1
netsh wlan connect name="Njtech-Home" interface="WLAN" | Out-Null

# 10. Enable proxy and start process
startProcess

# 11. Exit Script
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "All done, exit right now."
Exit
