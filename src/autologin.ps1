# 0. Hide global progress bar
$progressPreference = "silentlyContinue"
$isEnableProxy = $false

function checkWiFiConnection {
    cmd /c "ping baidu.com -n 1 -w 1000 >nul 2>nul"
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
    # Enable proxy again
    if ($isEnableProxy) {
        Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Enabling system proxy..."
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -Value 1
    }
    # Start QQ and Clash
    # if (!((Get-Process | Select-Object ProcessName).ProcessName -contains "QQ")) {
    #     Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Starting QQ..."
    #     Start-Process -FilePath "QQ" -RedirectStandardError Out-Null
    # }
    # if (!((Get-Process | Select-Object ProcessName).ProcessName -contains "Clash for Windows")) {
    #     Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Starting Clash..."
    #     Start-Process -FilePath "Clash for Windows" -RedirectStandardError Out-Null
    # }
}

# 1. Check profile file
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Loading login profile..."
if (!(Test-Path -Path $PSScriptRoot\profile.json)) {
    Write-Host "[ERROR] " -ForegroundColor Red -NoNewline; Write-Host "Login profile not exist, exit right now."
    Exit
}

# 2. Check WiFi Connection
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Checking whether you are connected..."
if (checkWiFiConnection) {
    Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "WiFi already connected, exit right now."
    startProcess
    Exit
}

# 3. Check whether Njtech-Home exists
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Checking whether Njtech-Home available..."
if (!(isNjtechExist)) {
    Write-Host "[ERROR] " -ForegroundColor Red -NoNewline; Write-Host "Njtech-Home not available, exit right now."
    Exit
}

# 4. Connect Njtech-Home
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Loading Njtech-Home network..."
netsh wlan connect name="Njtech-Home" interface="WLAN" | Out-Null
while (!(Test-NetConnection "u.njtech.edu.cn" -WarningAction SilentlyContinue -InformationLevel Quiet)) {}

# 5. Check WiFi Connection
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Checking whether you are connected..."
if (checkWiFiConnection) {
    Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "WiFi already connected, exit right now."
    startProcess
    Exit
}

# 6. Disable Proxy
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Disabling system proxy..."
if ( (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings").ProxyEnable -eq "1") {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -Value 0
    $isEnableProxy = $true
}

# 7. Post data to remote host
# 7.1 Load profile information
$MyProfile = Get-Content $PSScriptRoot\profile.json -Raw | ConvertFrom-Json

# 7.2 Provider hash table
$provider = @{
    "cmcc"    = "中国移动"
    "telecom" = "中国电信"
}

# 7.3 Get and post URL
$geturl = "https://u.njtech.edu.cn/cas/login?service=https%3A%2F%2Fu.njtech.edu.cn%2Foauth2%2Fauthorize%3Fclient_id%3DOe7wtp9CAMW0FVygUasZ%26response_type%3Dcode%26state%3Dnjtech%26s%3Df682b396da8eb53db80bb072f5745232"
$posturl = "https://u.njtech.edu.cn"

# 7.4 Send post data
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Sending your profile to host..."
$r = Invoke-WebRequest -Uri $geturl -SessionVariable s
$form = $r.Forms[0]
$form.Fields["username"] = $MyProfile.username
$form.Fields["password"] = $MyProfile.password
$form.Fields["channelshow"] = $provider[$MyProfile.provider]
$form.Fields["channel"] = '@' + $MyProfile.provider
$posturl = $posturl + $form.Action
$r = Invoke-WebRequest -Uri $posturl -WebSession $s -Method Post -Body $form
Write-Host "[INFO] " -ForegroundColor Green -NoNewline; Write-Host "Data Sending finished."

# 8. Check WiFi Connection
Start-Sleep -Seconds 1
if (checkWiFiConnection) {
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
