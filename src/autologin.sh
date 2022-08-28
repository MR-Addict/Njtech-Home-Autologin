#! /bin/bash

# Store data in njtech_home_html.txt and njtech_home_cookie
curl -skL i.njtech.edu.cn -c njtech_home_cookie.txt -o njtech_home_html.txt

username="your_username"
password="your_password"
channelshow="中国电信&channel=@telecom"
#channelshow="中国移动&channel=@cmcc"

posturl="https://u.njtech.edu.cn/cas/login?service=https%3A%2F%2Fu.njtech.edu.cn%2Foauth2%2Fauthorize%3Fclient_id%3DOe7wtp9CAMW0FVygUasZ%26response_type%3Dcode%26state%3Dnjtech%26s%3Df682b396da8eb53db80bb072f5745232"
useragent="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36 Edg/99.0.1150.55"

lt=$(cat njtech_home_html.txt|grep -o -E 'LT-.{39}'|head -1|tail -c 43)
execution=$(cat njtech_home_html.txt|grep -o -E 'name="execution" value=".{4}'|head -1|tail -c 5)
insert_cookie=$(grep "insert_cookie" njtech_home_cookie.txt|awk '{print $7}')
JSESSIONID=$(grep "JSESSIONID" njtech_home_cookie.txt|awk '{print $7}'|head -1)

cookie="Cookie: JSESSIONID="$JSESSIONID"; insert_cookie="$insert_cookie
form_data="username="$username"&password="$password"&channelshow="$channelshow"&lt="$lt"&execution="$execution"&_eventId=submit&login=提交"

curl -kL -X POST "$posturl" -H "$useragent" -H "$cookie" -d "$form_data"
