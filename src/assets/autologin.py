import json
import requests
from bs4 import BeautifulSoup

geturl = "https://u.njtech.edu.cn/cas/login?service=https%3A%2F%2Fu.njtech.edu.cn%2Foauth2%2Fauthorize%3Fclient_id%3DOe7wtp9CAMW0FVygUasZ%26response_type%3Dcode%26state%3Dnjtech%26s%3Df682b396da8eb53db80bb072f5745232"
posturl = "https://u.njtech.edu.cn/cas/login;jsessionid=65B9C37DFC296E1DE315076359292F44.TomcatB?service=https%3A%2F%2Fu.njtech.edu.cn%2Foauth2%2Fauthorize%3Fclient_id%3DOe7wtp9CAMW0FVygUasZ%26response_type%3Dcode%26state%3Dnjtech%26s%3Df682b396da8eb53db80bb072f5745232"

# load profile json file
profile = json.load(open("./assets/profile.json"))
provider = {
    "cmcc": "中国移动",
    "telecom": "中国电信"
}
# define a msedge headers
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36 Edg/99.0.1150.55'
}

# implement a Session object
s = requests.Session()
s.headers.update(headers)

# get login page
r = s.get(geturl)

# find lt and execution payload information using BeautifulSoup
soup = BeautifulSoup(r.content, "html.parser")
lt = soup.find('input', attrs={'name': 'lt'})['value']
execution = soup.find('input', attrs={'name': 'execution'})['value']
# load payload
payload = {
    'username': profile["username"],
    'password': profile["password"],
    "channelshow": provider[profile['provider']],
    "channel": '@'+profile['provider'],
    'lt': lt,
    'execution': execution,
    '_eventId': 'submit',
    'login': '登录',
}
# post data
r = s.post(posturl, data=payload)

# close Session
s.close()
