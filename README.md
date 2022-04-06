# 南京工业大学校园网自动登录Powershell版

## 1. 主要功能

- [x] 自动登录
- [x] 检查网络是否已经连接
- [x] 检查校园网是否在访问范围内
- [x] 联网前先关闭电脑的手动代理
- [x] 登录结束后检查网络是否连接成功
- [x] 关闭跳转的默认浏览器
- [x] 连接成功后发出哔的提示音
- [x] 实现自动配置开机自启任务
- [x] 实现休眠结束后自动启动任务
- [ ] 实现连接结束后自动启动其他任务
- [ ] 实现后台无弹窗运行

## 2. 准备

- 配置Windows Powershell权限
- 配置登录信息

第一步，在一般情况下，Windows是默认Windows Powershell没有执行脚本的权限的，你可以通过以下命令查看你的Windows Powershell的权限：

```ps1
Get-ExecutionPolicy
```

如果返回的是`Restricted `，那就说明你的Windows Powershell没有执行脚本的权限。你可以通过管理员重新打开Windows Powershell，然后再输入以下命令就可以了：

```ps1
Set-ExecutionPolicy RemoteSigned
```

第二步，由于登录时需要`账号`，`密码`和`运营商`的信息，同时本脚本可以帮大家自动关闭跳转的`浏览器`，这些信息都放在了`profile.json`配置文件中，默认路径是和`autologin.ps1`同一路径。克隆时没有这个文件，需要大家自己配置。profile的配置信息如下：

```json
{
  "username": "学号/工号",
  "password": "密码",
  "provider": "运营商",
  "browser": "跳转的浏览器程序名"
}
```

其中运营商只能填两个，移动是`cmcc`，电信是`telecom`。

我也整理了一些主流的浏览器名称，把对应的浏览器程序名填入就可以了。如果下面没有你使用的浏览器，你可以自己打开任务管理器查看浏览器的程序名。如果你不想使用这个功能可以将浏览器的程序名`设置为空`。

| 浏览器用户名 | 浏览器程序名 |
| :----------: | :----------: |
|  微软浏览器  |    msedge    |
|  谷歌浏览器  |    chrome    |
|  火狐浏览器  |   firefox    |
|   IE浏览器   |   iexplore   |
|  联想浏览器  |  SLBrowser   |

下面是一个示例：

```json
{
  "username": "XXXXXXXXXXXX",
  "password": "XXXXXXXXXXXX",
  "provider": "telecom",
  "browser": "msedge"
}
```

最后，你的文件结构应该如下：

- src
  - autologin.ps1
  - setup.ps1
  - profile.json

> 注意：为了方便大家使用，在`src`目录下有一个`setup.ps1`的文件，双击运行后跟着指示操作就可以完成登录信息的配置。同时`setup`脚本也可以帮你自动配置开机自启和休眠结束自启两个定时任务，但是需要管理员权限才能实现自动配置。

## 3. 使用

双击`src`文件夹下的`autologin.ps1`直接运行即可。如果你配置了开机自启和休眠结束自启，那么本脚本会在相应事件下自动执行。

> 注意：由于本项目是使用Powershell脚本，而目前最新的`Powershell 7.0`版本是一个支持跨平台的脚本语言，因此理论上可以在任何系统上使用。同时本脚本是在`Windows Powershel 5.1`环境下测试的，更高或者更低都有可能存在部分命令不兼容的情况。
