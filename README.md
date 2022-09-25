# 南京工业大学校园网自动登录脚本Bash版

## 1. 说明

Bash版本的自动登录脚本适用于Linux系统。

我写此脚本的目的是用于路由器自动登录，Linux系统可以使用本Bash版本，也可以参考基于Python版本的[Requests分支](https://github.com/MR-Addict/Njtech-Home-Autologin/tree/Requests)。

个人建议Linux系统使用Bash版本，因为代码更加简洁。

以下是脚本使用到的命令，请确保你的路由器或者Linux系统包含这些命令：

- curl
- grep
- tail
- awk

## 2. 使用

复制本分支`src`目录下的`autologin.sh`脚本，将开头的`username`和`password`改为你的学号和密码就可以了；同时记得取消注释你对应的供应商。

```bash
username="your_username"
password="your_password"
channelshow="中国电信&channel=@telecom"
#channelshow="中国移动&channel=@cmcc"
```

> 提示：如果你是Linux用户，相信对开机自启或者定时任务因该不陌生，可以自行部署。
