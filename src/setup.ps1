# Ask for administrator privilege
if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
        Exit;
    }
}

# Profile configuration
Write-Host "Do you want to configure your profile?"
$choice = Read-Host -Prompt "[Y/y]Yes [N/n]No"
if ($choice -eq "Y") {
    $username = Read-Host -Prompt "Input your username"
    $password = Read-Host -Prompt "Input your password"
    $provider = Read-Host -Prompt "Input your provider"
    $browser = Read-Host -Prompt "Input your redirected browser"
    $customProfile = @{
        "username" = $username
        "password" = $password
        "provider" = $provider
        "browser"  = $browser
    }
    $customProfile | ConvertTo-Json | Out-File profile.json -Encoding utf8
    Write-Host ($customProfile | ConvertTo-Json)
}

# Scheduled task configuration
Write-Host "Do you want to create startup and workstation unlock tasks for autologin or delete them?"
$choice = Read-Host -Prompt "[Y/y]Yes [N/n]No [D/d]Delete"
if ($choice -ne "N") {
    # Set poweshell executionpolicy
    Write-Host "Configurating autologin tasks..."
    #Create taskname
    $taskName = "Njtech-Home-Autologin-Script"
    # Create Triggers
    $stateChangeTrigger = Get-CimClass -Namespace ROOT\Microsoft\Windows\TaskScheduler -ClassName MSFT_TaskSessionStateChangeTrigger
    $onUnlockTrigger = New-CimInstance -CimClass $stateChangeTrigger -Property @{ StateChange = 8 } -ClientOnly
    $logonTrigger = New-ScheduledTaskTrigger -AtLogOn
    $taskTriggers = $onUnlockTrigger, $logonTrigger
    # Create task optional settings
    $taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -WakeToRun
    # Create action
    $taskAction = New-ScheduledTaskAction -Execute "cmd" -Argument "/c powershell -Version 5.1 -ExecutionPolicy RemoteSigned -File `"$PSScriptRoot\autologin.ps1`""
    # Description
    $taskDescription = "This is a script for autologin Njtech-Home Network, written by Mr-Addict. You can find more information on my github: https://github.com/MR-Addict/Njtech-Home-Autologin"
    if ($choice -eq 'Y') {
        # Register scheduled task
        Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue -OutVariable isTaskExist
        if ($isTaskExist) {
            Set-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTriggers -Settings $taskSettings
        }
        else {
            Register-ScheduledTask -TaskName $taskName  -Action $taskAction -Trigger $taskTriggers -Settings $taskSettings -Description $taskDescription
        }
    }
    else {
        # Unregister scheduled task
        Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue -OutVariable isTaskExist
        if ($isTaskExist) {
            Unregister-ScheduledTask -TaskName $taskName
        }
        else {
            Write-Host "Sorry you haven't created them yet"
        }
    }
}
# Exit set up script
Pause
exit