# 南京工业大学校园网自动登录Python脚本Requests版

## 1. 准备

- 安装python
- 配置登录信息
- 编译python文件

第一步，相信大家都是有装python的，这一步就直接跳过了，没有安装的请前往官网下载。

第二步，由于登录需要账号，密码和运营商的信息，这些需要大家在`src/assets/`文件夹下自己新建一个`profile.json`文件并配置相关信息。格式如下：

```json
{
  "username": "YOUR_USERNAME",
  "password": "YOUR_PASSWORD",
  "provider": "YOUR_PROVIDER"
}
```

其中运营商只能填两个，移动是`cmcc`，电信是`telecom`。

第三步，因为编译后的python文件运行起来更加快速，因此建议使用编译的文件，在`assets`文件夹下可以使用以下命令编译：

```shell
pyinstaller -F autologin.py
```

最后，你的文件树应该如下：

- autologin.bat
- assets
  - autologin.py
  - msedgedriver.exe
  - profile.json
  - dist
    - autologin.exe

## 2. 使用

> 注意：本项目仅适用Windows

双击`src`文件夹下的`autologin.bat`直接运行即可。

## 3. 主要功能

- [x] 自动登录
- [x] 开机自启
- [x] 检查网络是否已经连接
- [x] 检查校园是否在访问范围
- [x] 联网前先关闭电脑的手动代理
- [x] 登录结束后检测网络是否连接成功
- [x] 关闭跳转的Microsoft Edge浏览器