# Oracle-server-keep-alive-script

[![Hits](https://hits.spiritlhl.net/Oracle-server-keep-alive-script.svg?action=hit&title=Hits&title_bg=%23555555&count_bg=%2324dde1&edge_flat=false)](https://hits.spiritlhl.net)

## 甲骨文服务器保活脚本

适配系统：已在Ubuntu 20+，Debian 10+, Centos 7+, Oracle linux 8+，AlmaLinux 8.5+

上述系统验证无问题，别的主流系统应该也没有问题

可选占用：CPU，内存，带宽

安装完毕后如果有问题请卸载脚本反馈问题(重复卸载也没问题)

所有资源(除了CPU)可选默认配置则动态占用，实时调整，避免服务器有别的任何资源已经超过限额了仍然再占用资源

为避免GitHub的CDN抽风加载不了新内容，所有新更新已使用[Gitlab仓库](https://gitlab.com/spiritysdx/Oracle-server-keep-alive-script)

由于speedtest-go的release依赖于GitHub，所以请检查 [www.githubstatus.com](https://www.githubstatus.com/) ,有问题时无法安装带宽占用

请留意脚本当前更新日期：2023.09.24.08.37

**由于友人实测，资源占用感觉也是玄学，一个号四个服务器全部停机，但号还在，也有人一直不占用，但就是没停机的问题，所以该项目将长期保持现有状态，非必要不再更新**

**也有说要在上面解析一个网址做一个网站挂着的，感觉也是玄学，自己测试吧**

### 说明

选项1安装，选项2卸载，选项3更新安装引导脚本，选项4退出脚本

安装过程中无脑回车则全部可选的占用都占用，不需要什么占用输入```n```再回车

如果选择带宽占用，默认使用常驻服务模式（`bandwidth_occupier.service`）自动随机下载占用，无需再选择speedtest-go或wget

带宽策略为：每10秒到1小时随机触发一次下载，单次下载大小在1KB到1GB之间，并且间隔越久允许下载的文件上限越高

```
curl -L https://gitlab.com/spiritysdx/Oracle-server-keep-alive-script/-/raw/main/oalive.sh -o oalive.sh && chmod +x oalive.sh && bash oalive.sh
```

或

```
bash oalive.sh
```

或

```
bash <(wget -qO- --no-check-certificate https://gitlab.com/spiritysdx/Oracle-server-keep-alive-script/-/raw/main/oalive.sh)
```

### 特点

- CPU占用支持按系统总负载动态调整（默认每5秒检测一次）：低于25%时逐步增加占用，高于70%时逐步减少或暂停，占用恢复时会逐步回升。
- 内存占用可按较短周期检测并动态调整（当前默认10秒检测一次）。
- 带宽占用使用常驻服务随机触发：每10秒到1小时随机下载一次大小在1KB至1GB之间的文件，下载间隔越久下载大文件上限越高，只进行下载而不保存。在下载过程中会占用硬盘空间，但在下载完成后会自动释放。
- 提供一键卸载所有占用服务的选项，卸载将删除所有脚本、服务、任务、守护进程和开机自启设置。
- 提供一键检查更新的功能，更新范围仅限于脚本更新。**请在更新后重新设置占用服务**
- 对所有进程执行增加唯一性检测，避免重复运行，使用PID文件进行判断。

如若不希望一键的，希望自定义设置时间的，请查看[README_CRON.md](https://gitlab.com/spiritysdx/Oracle-server-keep-alive-script/-/blob/main/%20README_CRON.md)自行设置定时任务

### 友链

VPS融合怪测评项目

Go版本：https://github.com/oneclickvirt/ecs

Shell版本：https://github.com/spiritLHLS/ecs

一键虚拟化项目

国内 https://virt.spiritlhl.net/

国际 https://www.spiritlhl.net/

### 广告



## Stargazers over time

[![Stargazers over time](https://starchart.cc/spiritLHLS/Oracle-server-keep-alive-script.svg)](https://starchart.cc/spiritLHLS/Oracle-server-keep-alive-script)
