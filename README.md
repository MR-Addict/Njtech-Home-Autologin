# 南京工业大学校园网自动登录脚本Powershell版

## 1. 主要功能

- [x] 自动登录
- [x] 检查网络是否已经连接
- [x] 检查校园网是否在访问范围内
- [x] ~关闭手动代理~规避手动代理（如果你使用VPN会存在代理问题）
- [x] ~登录结束后检查网络是否连接成功~
- [x] 关闭跳转的默认浏览器
- [x] ~连接成功后发出哔的提示音~
- [x] 实现开机后自动执行脚本
- [x] 实现解锁后自动执行脚本
- [ ] 实现登录结束后自动启动其他任务
- [ ] 实现后台无弹窗运行

## 2. 准备

- 配置Windows Powershell权限
- 配置登录信息
- 配置开机自启和解锁自启两个定时任务

### 2.1 配置Windows Powershell权限

第一步，一般情况下，Windows默认Windows Powershell没有执行脚本的权限，你可以通过以下命令查看你的Windows Powershell的权限：

```ps1
Get-ExecutionPolicy
```

如果返回的是`Restricted`，`Allsigned`，`Default`或者`Undefined`，那就说明你的Windows Powershell没有执行脚本的权限。你可以通过管理员重新打开Windows Powershell，然后再输入以下命令就可以了（建议使用的权限是`RemoteSigned`，没有必要使用更高级的权限，那样不安全）：

```ps1
Set-ExecutionPolicy RemoteSigned
```

### 2.2 配置登录信息

第二步，由于登录时需要`账号`，`密码`和`运营商`的信息，同时本脚本可以帮大家自动关闭跳转的`浏览器`，这些信息都放在了`profile.json`配置文件中，默认路径是和`autologin.ps1`同一路径。克隆时没有这个文件，需要手动配置或者在下一步使用脚本配置。profile的配置信息如下：

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

下面是一个profile的示例：

```json
{
  "username": "XXXXXXXXXXXX",
  "password": "XXXXXXXXXXXX",
  "provider": "telecom",
  "browser": "msedge"
}
```

### 2.3 配置开机自启和解锁自启

第三步，配置开机自启和解锁自启可以免去手动运行脚本的麻烦。这里我使用的Windows自带的`Task Scheduler`应用程式，大部分软件的自动更新功能就是使用的它。你可以手动配置定时任务，这里我为了方便直接通过Windows Powershell脚本进行配置，也就是项目中的`setup.ps1`脚本。

这个脚本除了可以配置自启的任务，同时也可以第二步配置登录信息的相关内容，运行时可能需要管理员权限。记得先完成`第一步的Windows Powershell权限配置`，不然无法运行脚本。（双击运行setup脚本时如果直接进入了编辑模式，你可能就需要配置ps1文件的打开方式，或者右击文件选择`使用Powershell运行`。）

运行setup脚本时首先会询问你是否需要配置登录信息，如果你还没有`创建`或者想要`更新`已有信息可以选择Y，然后依次填入你的学号，密码，运营商以及跳转的浏览器程序名；如果想要跳过配置可以选择N：

```plaintext
Do you want to configure your profile?
[Y/y]Yes [N/n]No: y
Input your username: XXXXXXXXXXXX
Input your password: XXXXXXXXXXXX
Input your provider: cmcc
Input your redirected browser: msedge
```

接着会询问你是否需要创建或者删除定时任务，如果你还没有`创建`或者想要`更新`任务可以选择Y，然后脚本会自动创建两个定时任务。当然如果你后面不想使用这个功能了，也可以重新运行setup脚本，选择`删除任务`就可以了：

```plaintext
Do you want to create startup and workstation unlock tasks for autologin or delete them?
[Y/y]Yes [N/n]No [D/d]Delete: y
Configurating autologin tasks...
```

最后，你的文件结构应该如下：

- src
  - autologin.ps1
  - setup.ps1
  - profile.json

## 3. 使用

双击`src`文件夹下的`autologin.ps1`直接运行即可，

如果你配置了开机自启和解锁自启，那么本脚本会在相应事件下自动执行。

> 注意：本脚本是在`Windows Powershel 5.1`环境下测试的，更高或者更低都有可能存在部分命令不兼容的情况，使用Windows 10系统的话不必担心这个问题，默认的的Windows Powershell就是5.1版本。同时由于本项目是使用Powershell脚本，而目前最新的`Powershell 7.0`版本更是支持跨平台，因此理论上稍作修改是可以在任何系统上使用的。

## 4. 说明

有任何问题和建议都欢迎大家`issue`或者`pull request`。
