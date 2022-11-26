# 南京工业大学校园网自动登录Python脚本Requests版

## 1. 安装和配置python

### 1.1 安装python

相信大家都是有装python的，这一步就直接跳过了，没有安装的请前往[官网下载](https://www.python.org/downloads/)，建议安装**3.10**及以下的版本。

### 1.2 安装依赖

克隆文档：

```bash
git clone https://github.com/MR-Addict/Njtech-Home-Autologin.git
```

切换分支：

```bash
git checkout Requests
```

安装依赖：

```bash
pip install -r requirements.txt
```

## 2. 配置登录信息

由于登录时需要账号，密码和运营商的信息，这些需要大家在`src/`文件夹下自己新建一个`profile.json`文件并配置相关信息。注意，运营商只能填两个，移动是`cmcc`，电信是`telecom`格式如下：

```json
{
  "username": "学号/工号",
  "password": "密码",
  "provider": "运营商",
}
```

## 3. 使用

运行`src`文件夹下的`autologin.py`即可。

## 4. 说明

了解本项目的其他分支情况可参考此[Wiki页面](https://github.com/MR-Addict/Njtech-Home-Autologin/wiki)
