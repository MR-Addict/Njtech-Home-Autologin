# 0. Import packages
import os
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
captchaapiurl = "http://202.119.245.12:45547"
# 1.3 implement a Session object
session = requests.Session()
session.headers.update(useragent)
# 1.5 get login page
print("[INFO] Sending get requests...")
res = session.get(geturl)

# 2. Handle response
# 2.1 Find lt and execution payload information using BeautifulSoup
print("[INFO] Parsing response html...")
soup = BeautifulSoup(res.content, "html.parser")
lt = soup.find('input', attrs={'name': 'lt'})['value']
execution = soup.find('input', attrs={'name': 'execution'})['value']
_eventId = soup.find('input', attrs={'name': '_eventId'})['value']
login = soup.find('input', attrs={'name': 'login'})['value']
posturl = posturl + soup.find('form', id='fm1').get('action')

with session.get(captchageturl, stream=True) as res:
    with open("captcha.jpg", 'wb') as f:
        shutil.copyfileobj(res.raw, f)
res = session.post(captchaapiurl, files={"captcha": open(captchapath, 'rb')})
captcha = json.loads(res.text)["message"]
os.remove(captchapath)
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
res = session.post(posturl, data=payload)
session.close()

# 3. Check WiFi connection
soup = BeautifulSoup(res.content, "html.parser")
if soup.find("div", {"class": "user-msg-info"}) is not None:
    print("[INFO] Autologin succeed!")
else:
    print("[INFO] Autologin failed!")
