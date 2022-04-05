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
Write-Host "Your profile has created, press any key to exit!"
[console]::ReadKey()
exit