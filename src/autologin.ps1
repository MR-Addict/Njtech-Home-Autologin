$geturl = "https://u.njtech.edu.cn/cas/login?service=https%3A%2F%2Fu.njtech.edu.cn%2Foauth2%2Fauthorize%3Fclient_id%3DOe7wtp9CAMW0FVygUasZ%26s_type%3Dcode%26state%3Dnjtech%26s%3Df682b396da8eb53db80bb072f5745232"
$posturl = "https://u.njtech.edu.cn/cas/login;jsessionid=65B9C37DFC296E1DE315076359292F44.TomcatB?service=https%3A%2F%2Fu.njtech.edu.cn%2Foauth2%2Fauthorize%3Fclient_id%3DOe7wtp9CAMW0FVygUasZ%26s_type%3Dcode%26state%3Dnjtech%26s%3Df682b396da8eb53db80bb072f5745232"
$r = Invoke-WebRequest -Uri $geturl -SessionVariable s
$form = $r.Forms[0]
$form.Fields["username"] = "202021007063"
$form.Fields["password"] = "@cjw20001212"
$form.Fields["channelshow"] = "中国电信"
$form.Fields["channel"] = "@telecom"
$r = Invoke-WebRequest -Uri $posturl -WebSession $s -Method Post -Body $form
Write-Host $r.Content
Write-Host $r.StatusCode
ping baidu.com
pause