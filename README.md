# 南京工业大学校园网自动登录Python脚本

## 1. 准备

首先安装python的`selenium`包，你可以使用以下命令安装selenium包，前提是你的电脑有安装python，经过测试阿里云有这个包：

```shell
pip install -i https://mirrors.aliyun.com/pypi/simple/ selenium
```

另外你需要下载`chromedriver`，但是你直接克隆这个项目就可以了，不需要自己下载。

## 2. 使用

运行前，请填写`src/profile.json`有关账号的信息，包括`用户名/学号`，`密码`以及`运营商`，其中运营商只能填写两个：

|  type   |   name   |
| :-----: | :------: |
|  cmcc   | 中国移动 |
| telecom |  中国电  |

```json
{
  "username": "YOUR_USERNAME",
  "password": "YOUR_PASSWORD",
  "provider": "YOU_PROVIDER"
}
```

在Windows点击`autologin.bat`直接运行即可。
