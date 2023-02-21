import json
import ddddocr
import requests
from bs4 import BeautifulSoup


class autologin():
    def __init__(self, username, password, provider):
        self.username = username
        self.password = password
        self.channel = '@'+provider
        if provider == "cmcc":
            self.channelshow = "中国移动"
        elif provider == "telecom":
            self.channelshow = "中国电信"
        self.ocr = ddddocr.DdddOcr(
            show_ad=False, import_onnx_path="models/captcha.onnx",
            charsets_path="models/charsets.json")

    def login(self):
        # 1. Variables
        get_url = "https://i.njtech.edu.cn"
        post_url = "https://u.njtech.edu.cn"
        captcha_url = "https://u.njtech.edu.cn/cas/captcha.jpg"
        useragent = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36 Edg/99.0.1150.55'
        }
        # 2 Create soup
        session = requests.Session()
        session.headers.update(useragent)
        try:
            res = session.get(get_url)
        except:
            return False
        # 3. Parse html
        soup = BeautifulSoup(res.content, "html.parser")
        lt = soup.find('input', attrs={'name': 'lt'})['value']
        execution = soup.find('input', attrs={'name': 'execution'})['value']
        _eventId = soup.find('input', attrs={'name': '_eventId'})['value']
        login = soup.find('input', attrs={'name': 'login'})['value']
        post_url = post_url + soup.find('form', id='fm1').get('action')
        captcha = self.ocr.classification(session.get(captcha_url).content)
        payload = {
            'username': self.username,
            'password': self.password,
            "channel": self.channel,
            "channelshow": self.channelshow,
            'lt': lt, 'captcha': captcha,
            'execution': execution,
            '_eventId': _eventId,
            'login': login,
        }
        # 4. Post and check
        res = session.post(post_url, data=payload)
        soup = BeautifulSoup(res.content, "html.parser")
        session.close()
        if soup.find("div", {"class": "user-msg-info"}) is not None:
            return True
        else:
            return False


if __name__ == '__main__':
    with open("profile.json", 'r') as f:
        data = json.load(f)
        home = autologin(data["username"], data["password"], data["provider"])
        success = home.login()
        if success:
            print("Login succeeded!")
        else:
            print("Login failed!")
