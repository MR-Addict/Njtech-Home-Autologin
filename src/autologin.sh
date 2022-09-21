#! /bin/bash

username="your_username"
password="your_password"
channelshow="中国电信&channel=@telecom"
#channelshow="中国移动&channel=@cmcc"

if ping -w 1 -c 1 baidu.com > /dev/null 2>&1; then
  echo "[WARN] WiFi already connected!" && exit
elif ping -w 1 -c 1 njtech.edu.cn > /dev/null 2>&1; then
  echo "[INFO] Execute autologin script..."
else
  echo "[WARN] Cannot access Njtech-Home!"
  echo "[FAIL] Cannot access Njtech-Home!" >> log.txt && exit
fi

# Store data in login_get_html.html and login_cookie.txt
echo "[INFO] Fetching data from remote host..."
curl -skL i.njtech.edu.cn -c login_cookie.txt -o login_get_html.html

posturl="https://u.njtech.edu.cn/cas/login?service=https%3A%2F%2Fu.njtech.edu.cn%2Foauth2%2Fauthorize%3Fclient_id%3DOe7wtp9CAMW0FVygUasZ%26response_type%3Dcode%26state%3Dnjtech%26s%3Df682b396da8eb53db80bb072f5745232"
useragent="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36 Edg/99.0.1150.55"

lt=$(cat login_get_html.html|grep -o -E 'LT-.{39}'|head -1|tail -c 43)
execution=$(cat login_get_html.html|grep -o -E 'name="execution" value=".{4}'|head -1|tail -c 5)
insert_cookie=$(grep "insert_cookie" login_cookie.txt|awk '{print $7}')
JSESSIONID=$(grep "JSESSIONID" login_cookie.txt|awk '{print $7}'|head -1)

cookie="Cookie: JSESSIONID="$JSESSIONID"; insert_cookie="$insert_cookie
form_data="username="$username"&password="$password"&channelshow="$channelshow"&lt="$lt"&execution="$execution"&_eventId=submit&login=提交"

# post data
echo "[INFO] Post data to remote host..."
curl -kL -X POST "$posturl" -H "$useragent" -H "$cookie" -d "$form_data" -o login_post_html.html > /dev/null 2>&1

# check wheather login succeed
if grep -q oauth2/logout login_post_html.html ;then
  echo "[INFO] Autologin Succeeded!"
  echo "[DONE] Autologin Succeeded!" >> log.txt
else
  echo "[WARN] Autologin Failed!"
  echo "[FAIL] Autologin Failed!" >> log.txt
fi
rm login_*

