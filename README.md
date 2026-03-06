# Oracle-server-keep-alive-script

[![Hits](https://hits.spiritlhl.net/Oracle-server-keep-alive-script.svg?action=hit&title=Hits&title_bg=%23555555&count_bg=%2324dde1&edge_flat=false)](https://hits.spiritlhl.net)

## 甲骨文服务器保活脚本

适配系统：已在Ubuntu 20+，Debian 10+, Centos 7+, Oracle linux 8+，AlmaLinux 8.5+

上述系统验证无问题，别的主流系统应该也没有问题

可选占用：CPU，内存，带宽

安装完毕后如果有问题请卸载脚本反馈问题(重复卸载也没问题)

所有资源(除了CPU)可选默认配置则动态占用，实时调整，避免服务器有别的任何资源已经超过限额了仍然再占用资源

为避免 GitHub CDN 抖动，原项目更新主要在 GitLab；本仓库同步并维护可直接用于部署的版本。

上游项目（原作者）：[spiritLHLS/Oracle-server-keep-alive-script](https://github.com/spiritLHLS/Oracle-server-keep-alive-script)

当前维护仓库（推荐直接部署）：[Smith-106/Oracle-server-keep-alive-script](https://github.com/Smith-106/Oracle-server-keep-alive-script)

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

### 快速开始（推荐）

#### 宿主机直接部署

```bash
git clone https://github.com/Smith-106/Oracle-server-keep-alive-script.git
cd Oracle-server-keep-alive-script
sudo bash oalive.sh
```

#### 一键远程拉取执行

```bash
curl -L https://raw.githubusercontent.com/Smith-106/Oracle-server-keep-alive-script/main/oalive.sh -o oalive.sh && chmod +x oalive.sh && sudo bash oalive.sh
```

#### 安装后常用命令

```bash
# 查看三项服务状态
sudo systemctl status cpu-limit.service memory-limit.service bandwidth_occupier.service --no-pager

# 查看带宽随机任务定时器（若启用）
sudo systemctl status bandwidth_occupier.timer --no-pager

# 查看近期日志
sudo journalctl -u cpu-limit.service -u memory-limit.service -u bandwidth_occupier.service -n 100 --no-pager
```


### 特点

- CPU占用支持按系统总负载动态调整（默认每5秒检测一次）：低于25%时逐步增加占用，高于70%时逐步减少或暂停，占用恢复时会逐步回升。
- 内存占用可按较短周期检测并动态调整（当前默认10秒检测一次）。
- 带宽占用使用常驻服务随机触发：每10秒到1小时随机下载一次大小在1KB至1GB之间的文件，下载间隔越久下载大文件上限越高，只进行下载而不保存。在下载过程中会占用硬盘空间，但在下载完成后会自动释放。
- 提供一键卸载所有占用服务的选项，卸载将删除所有脚本、服务、任务、守护进程和开机自启设置。
- 提供一键检查更新的功能，更新范围仅限于脚本更新。**请在更新后重新设置占用服务**
- 对所有进程执行增加唯一性检测，避免重复运行，使用PID文件进行判断。

### 卸载与清理

可在脚本菜单中选择“2. 卸载保活服务”一键卸载。

若需手动清理，可执行：

```bash
sudo systemctl disable --now cpu-limit.service memory-limit.service bandwidth_occupier.service bandwidth_occupier.timer 2>/dev/null || true
sudo rm -f /etc/systemd/system/cpu-limit.service /etc/systemd/system/memory-limit.service /etc/systemd/system/bandwidth_occupier.service /etc/systemd/system/bandwidth_occupier.timer
sudo systemctl daemon-reload
sudo systemctl reset-failed
sudo rm -f /usr/local/bin/cpu-limit.sh /usr/local/bin/memory-limit.sh /usr/local/bin/bandwidth_occupier.sh
sudo rm -rf /etc/speedtest-cli /var/lib/boinc
```



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
