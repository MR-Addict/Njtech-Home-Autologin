# 南京工业大学校园网自动登录Python脚本Requests版

## 1. 主要功能

- [x] 自动登录
- [x] 检查网络是否已经连接
- [x] 检查校园网是否在访问范围内
- [x] 联网前先关闭电脑的手动代理
- [x] 登录结束后检查网络是否连接成功
- [x] 关闭跳转的默认浏览器
- [x] 连接成功后发出哔的提示音
- [ ] 实现后台无弹窗运行
- [ ] 实现自动设置开机自启
- [ ] 完全使用batch而不是python实现自动登录

## 2. 准备

- 安装python
- 配置登录信息
- 编译python文件

第一步，相信大家都是有装python的，这一步就直接跳过了，没有安装的请前往官网下载。

第二步，由于登录时需要账号，密码和运营商的信息，同时本脚本可以帮大家自动关闭跳转的浏览器，这些需要大家在`src/assets/`文件夹下自己新建一个`profile.json`文件并配置相关信息。格式如下：

```json
{
  "username": "学号/工号",
  "password": "密码",
  "provider": "运营商",
  "browser": "跳转的浏览器程序名"
}
```

其中运营商只能填两个，移动是`cmcc`，电信是`telecom`。

我也整理了一些主流的浏览器名称，把对应的浏览器程序名填入就可以了，如果你不想使用这个功能可以将浏览器的程序名设置为空。

| 浏览器用户名 | 浏览器程序名 |
| :----------: | :----------: |
|  微软浏览器  |    msedge    |
|  谷歌浏览器  |    chrome    |
|  火狐浏览器  |   firefox    |
|   IE浏览器   |   iexplore   |
|  联想浏览器  |  SLBrowser   |

第三步，因为编译后的python文件运行起来更加快速，因此建议使用编译的文件，当然你需要事先安装`pyinstaller`，你可以使用以下命令安装这个包：

```batch
pip install -i https://mirrors.aliyun.com/pypi/simple/ pyinstaller
```

安装完成后，在`assets`路径下使用以下命令就可以编译python文件了：

```batch
pyinstaller -F autologin.py
```

最后，你的文件结构应该如下：

- guide.bat
- autologin.bat
- assets
  - \_\_pycache\_\_
  - build
  - dist
  - autologin.py
  - autologin.spec
  - profile.json

> 注意：为了方便大家使用，在`src`目录下有一个`guide.bat`的文件，双击运行后跟着指示操作就可以实现上面的三个要求

## 3. 使用

双击`src`文件夹下的`autologin.bat`直接运行即可。

如果你不想手动点击脚本，你可以将其设置为开机自启。有关如何设置开机自启大家可以自行百度，目前版本还不支持自动配置开机自启。

> 注意：本项目仅适用于Windows
