# 0. Import packages
import json
import requests
from bs4 import BeautifulSoup

# 1. Login preparations
# 1.1 Get url
geturl = "https://i.njtech.edu.cn"
posturl = "https://u.njtech.edu.cn"
# 1.2 Load profile information
profile = json.load(open("./profile.json"))
provider = {
    "cmcc": "中国移动",
    "telecom": "中国电信"
}
# 1.3 define a msedge useragent
useragent = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36 Edg/99.0.1150.55'
}
# 1.4 implement a Session object
s = requests.Session()
s.headers.update(useragent)
# 1.5 get login page
r = s.get(geturl)

# 2. Handle response
# 2.1 find lt and execution payload information using BeautifulSoup
soup = BeautifulSoup(r.content, "html.parser")
lt = soup.find('input', attrs={'name': 'lt'})['value']
execution = soup.find('input', attrs={'name': 'execution'})['value']
_eventId = soup.find('input', attrs={'name': '_eventId'})['value']
login = soup.find('input', attrs={'name': 'login'})['value']
posturl = posturl + soup.find('form', id='fm1').get('action')
# 2.2 Prepare post payload
payload = {
    'username': profile["username"],
    'password': profile["password"],
    "channelshow": provider[profile['provider']],
    "channel": '@'+profile['provider'],
    'lt': lt,
    'execution': execution,
    '_eventId': _eventId,
    'login': login,
}
# 2.3 Post data to host
r = s.post(posturl, data=payload)

# 3. close Session
s.close()
