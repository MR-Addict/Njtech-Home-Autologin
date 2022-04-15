# 0. Hide global progress bar
$progressPreference = "silentlyContinue"

# 1. Check profile file
Write-Host "Loading profile..."
if (!(Test-Path -Path $PSScriptRoot\profile.json)) {
    Write-Host "Profile not exist, exit right now."
    Exit
}

function checkWiFiConnection {
    $timeout = New-TimeSpan -Seconds 1
    $stopWatch = [System.Diagnostics.Stopwatch]::StartNew()
    do {
        if (Test-NetConnection "www.baidu.com" -WarningAction SilentlyContinue -InformationLevel Quiet) {
            return $true
        }
    } while ($stopWatch.elapsed -lt $timeout)
    return $false
}

# 2. Check WiFi Connection
Write-Host "Checking whether you are connected..."
if (checkWiFiConnection) {
    Write-Host "WiFi already connected, exit right now."
    Exit
}

# 3. Check whether Njtech-Home exists
Write-Host "Checking whether Njtech-Home available..."
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
if (!(isNjtechExist)) {
    Write-Host "Njtech-Home not available, exit right now."
    Exit
}

# 4. Connect Njtech-Home
Write-Host "Loading Njtech-Home network..."
netsh wlan connect name="Njtech-Home" interface="WLAN" | Out-Null
while (!(Test-NetConnection "u.njtech.edu.cn" -WarningAction SilentlyContinue -InformationLevel Quiet)) {}

# 5. Check WiFi Connection
Write-Host "Checking whether you are connected..."
if (checkWiFiConnection) {
    Write-Host "WiFi already connected, exit right now."
    Exit
}

# 6. Disable Proxy
Write-Host "Disabling system proxy..."
if ( (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings").ProxyEnable -eq "1") {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -Value 0
    $global:isEnableProxy = $true
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
$geturl = "https://u.njtech.edu.cn/cas/login?service=https%3A%2F%2Fu.njtech.edu.cn%2Foauth2%2Fauthorize%3Fclient_id%3DOe7wtp9CAMW0FVygUasZ%26s_type%3Dcode%26state%3Dnjtech%26s%3Df682b396da8eb53db80bb072f5745232"
$posturl = "https://u.njtech.edu.cn/cas/login;jsessionid=65B9C37DFC296E1DE315076359292F44.TomcatB?service=https%3A%2F%2Fu.njtech.edu.cn%2Foauth2%2Fauthorize%3Fclient_id%3DOe7wtp9CAMW0FVygUasZ%26s_type%3Dcode%26state%3Dnjtech%26s%3Df682b396da8eb53db80bb072f5745232"

# 7.4 Send post data
Write-Host "Sending your profile to host..."
$r = Invoke-WebRequest -Uri $geturl -SessionVariable s
$form = $r.Forms[0]
$form.Fields["username"] = $MyProfile.username
$form.Fields["password"] = $MyProfile.password
$form.Fields["channelshow"] = $provider[$MyProfile.provider]
$form.Fields["channel"] = '@' + $MyProfile.provider
$r = Invoke-WebRequest -Uri $posturl -WebSession $s -Method Post -Body $form
Write-Host "Data Sending finished"

# 8. Disconnect and connect WiFi
Write-Host "Disconnecting WiFi..."
Start-Sleep -Seconds 1
netsh wlan disconnect | Out-Null
Write-Host "Connecting WiFi again..."
Start-Sleep -Seconds 1
netsh wlan connect name="Njtech-Home" interface="WLAN" | Out-Null

# 9. Enable proxy again
Write-Host "Enabling system proxy..."
if ($isEnableProxy) {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -Value 1
}

# 10. Exit Script
Write-Host "All done, exit right now."
Exit