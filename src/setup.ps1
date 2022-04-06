Write-Host "Creating your profile..."
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
Write-Host "Your profile has created!"

# Set poweshell executionpolicy
try {
    if (!((Get-ExecutionPolicy).ToString() -eq "Restricted")) {
        Set-ExecutionPolicy RemoteSigned
    }
}
catch {
    Write-Host "You do not have enough rights, please open this as administrator"
    Pause
    exit
}

Write-Host "Configurating autologin tasks..."
#Create taskname
$taskName = "Njtech-Home-Autologin"
# Create Triggers
$stateChangeTrigger = Get-CimClass -Namespace ROOT\Microsoft\Windows\TaskScheduler -ClassName MSFT_TaskSessionStateChangeTrigger
$onUnlockTrigger = New-CimInstance -CimClass $stateChangeTrigger -Property @{ StateChange = 8 } -ClientOnly
$logonTrigger = New-ScheduledTaskTrigger -AtLogOn
$taskTriggers = $onUnlockTrigger, $logonTrigger
# Create action
$taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File $PSScriptRoot\autologin.ps1"
# Register scheduled task
Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue -OutVariable isTaskExist
if ($isTaskExist) {
    Set-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTriggers
}
else {
    Register-ScheduledTask -TaskName $taskName  -Action $taskAction -Trigger $taskTriggers
}

Write-Host "Task created, press any to exit"

[console]::ReadKey() | Out-Null
exit