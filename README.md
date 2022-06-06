# 南京工业大学校园网自动登录脚本Powershell版

## 1. 主要功能

- [x] 自动登录
- [x] 阻止浏览器跳转
- [x] 检查网络是否已经连接
- [x] 实现开机后自动执行脚本
- [x] 实现解锁后自动执行脚本
- [x] 检查校园网是否在访问范围内
- [x] 规避手动代理（如果你使用VPN会存在代理问题）
- [ ] 实现登录结束后自动启动其他任务
- [ ] 实现后台无弹窗运行

## 2. 准备

- 配置Windows Powershell权限
- 配置登录信息，定时任务和关闭浏览器跳转

### 2.1 配置Windows Powershell权限

第一步，一般情况下，Windows默认Windows Powershell没有执行脚本的权限，你可以通过以下命令查看你的Windows Powershell权限：

```ps1
Get-ExecutionPolicy
```

如果返回的是`Restricted`，`Allsigned`，`Default`或者`Undefined`，那就说明你的Windows Powershell没有执行脚本的权限。你可以`通过管理员权限`重新打开Windows Powershell，然后再输入以下命令（推荐的权限是`RemoteSigned`，不建议使用更高等级的权限）。

```ps1
Set-ExecutionPolicy RemoteSigned
```

### 2.2 配置登录信息、定时任务和关闭浏览器跳转

第二步，配置登录信息、定时任务和关闭浏览器跳转。这些功能都是可以直接通过运行setup脚本实现的。记得先完成`第一步的Windows Powershell权限配置`，不然无法运行脚本。（双击运行setup脚本时如果直接进入了编辑模式，你可能就需要配置ps1文件的打开方式，或者右击文件选择`使用Powershell运行`。）

运行setup脚本时首先会询问你是否需要配置登录信息，如果你还没有`创建`或者想要`更新`已有信息可以选择Y，然后依次填入你的学号，密码，运营商。其中运营商只能填两个，移动是`cmcc`，电信是`telecom`。如果你之前已经配置过了可以选择N跳过该配置。

```plaintext
Do you want to configure your profile?
[Y/y]Yes [N/n]No: y
Input your username: XXXXXXXXXXXX
Input your password: XXXXXXXXXXXX
Input your provider: cmcc
```

接着会询问你是否需要创建或者删除定时任务，如果你还没有`创建`或者想要`更新`任务可以选择Y。如果你已经创建过了可以选择N跳过配置。如果你后面不想让脚本自动执行可以选择D删除任务。

```plaintext
Do you want to create startup and workstation unlock tasks for autologin or delete them?
[Y/y]Yes [N/n]No [D/d]Delete: y
Configurating autologin tasks...
```

最后会询问你是否需要关闭浏览器自动跳转的功能。输入Y关闭跳转，输入N打开跳转。

```plaintext
Do you want to enable or disable browser auto directed globally?
[Y/y]Disable [N/n]Enable: y
Your browser auto directed disabled
```

> 注意：这里设置禁止浏览器跳转后，今后任何情况下浏览器都不会再跳转。如果你后面想要重新启用浏览器跳转功能可以重新运行脚本到此选项，选择N重新启用浏览器跳转。

## 3. 使用

双击`src`文件夹下的`autologin.ps1`直接运行即可。

如果你配置了开机自启和解锁自启，那么本脚本会在相应事件下自动执行。

![Preview-GIF](autologin.gif)

## 4. 说明

有任何问题和建议都欢迎大家`Issue`或`Pull request`。

> 注意：本脚本是在`Windows Powershel 5.1`环境下测试的，更高或者更低都有可能存在部分命令不兼容的情况。使用Windows 10、11系统的话不必担心这个问题，默认的的Windows Powershell就是5.1版本。
