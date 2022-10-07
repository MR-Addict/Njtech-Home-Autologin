# 0. Import packages
import json
import shutil
import requests
from bs4 import BeautifulSoup

# 1. Login preparations
# 1.1 Load profile information
print("[INFO] Loading your profile...")
profile = json.load(open("./profile.json"))
provider = {
    "cmcc": "中国移动",
    "telecom": "中国电信"
}
# 1.2 Get constants
geturl = "https://i.njtech.edu.cn"
posturl = "https://u.njtech.edu.cn"
useragent = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36 Edg/99.0.1150.55'
}

captchapath = "./captcha.jpg"
captchageturl = "https://u.njtech.edu.cn/cas/captcha.jpg"
captchaapiurl = "http://localhost:8000"
# 1.3 implement a Session object
s = requests.Session()
s.headers.update(useragent)
# 1.5 get login page
print("[INFO] Sending get requests...")
r = s.get(geturl)

# 2. Handle response
# 2.1 Find lt and execution payload information using BeautifulSoup
print("[INFO] Parsing response html...")
soup = BeautifulSoup(r.content, "html.parser")
lt = soup.find('input', attrs={'name': 'lt'})['value']
execution = soup.find('input', attrs={'name': 'execution'})['value']
_eventId = soup.find('input', attrs={'name': '_eventId'})['value']
login = soup.find('input', attrs={'name': 'login'})['value']
posturl = posturl + soup.find('form', id='fm1').get('action')

with s.get(captchageturl, stream=True) as r:
    with open("captcha.jpg", 'wb') as f:
        shutil.copyfileobj(r.raw, f)
res = s.post(captchaapiurl, files={"captcha": open(captchapath, 'rb')})
captcha = json.loads(res.text)["message"]
# 2.2 Prepare post payload
payload = {
    'username': profile["username"],
    'password': profile["password"],
    "channelshow": provider[profile['provider']],
    "channel": '@'+profile['provider'],
    'lt': lt,
    'captcha': captcha,
    'execution': execution,
    '_eventId': _eventId,
    'login': login,
}
# 2.3 Post data to host
print("[INFO] Sending your profile to host...")
r = s.post(posturl, data=payload)

# 3. close Session
print("[INFO] Auto login finished!")
s.close()
