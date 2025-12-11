# Clash MIX - 安装即用且运行稳定的透明代理模块

---

## 模块特性
1. **双模式支持：TUN 模式 + TPROXY 模式**  
   - **TUN 模式**（默认）：使用 Meta 内核内置 Tun 功能，开箱即用，兼容性最佳
   - **TPROXY 模式**（新增）：传统透明代理方式，参考 [AndroidTProxyShell](https://github.com/CHIZI-0618/AndroidTProxyShell) 实现

2. **极简设计，精简脚本，稳定体验**  
   完全重写的精简脚本，配合 Meta 官方模式，提供更加稳定的使用体验，代理更无感，上网更流畅。

3. **日志输出和配置管理便捷**  
   模块的日志输出和配置文件存放在 `/内部存储/Android/Clash` 文件夹中，现在可以更加方便地编辑配置文件和查看日志了。

4. **常用功能全支持**    
   - 在 Magisk 或 KSU 管理器内一键更新  
   - Action 按键支持快速重启内核
   - KSU管理器内置网页面板支持  
   - 更新或卸载模块时保留旧配置文件  
   - 通过模块开关控制内核的启停等功能  

---

## 安装方式
1. **卸载已安装的所有代理模块**  
   包括 Clash MIX 3.0。

2. **重启手机一次**  
   特别是之前使用3.0的用户，需要重启以恢复环境

3. **在面具/ksu中安装 Clash MIX 4.0 模块**  
   然后在 `/内部存储/Android/Clash/config.yaml` 文件中填写你的订阅链接。

4. **重启手机并解锁屏幕**  
   内核将自动启动。用 Chrome 等非国产浏览器打开 [http://127.0.0.1:9090/ui](http://127.0.0.1:9090/ui) 即可进入本地面板进行调整。

---

## TPROXY 模式使用指南

### 什么是 TPROXY？
TPROXY (Transparent Proxy) 是 Linux 内核提供的透明代理功能，通过 iptables/nftables 规则将流量重定向到代理程序，无需应用程序感知代理的存在。

### TPROXY vs TUN 模式对比

| 特性 | TUN 模式 | TPROXY 模式 |
|------|----------|-------------|
| 兼容性 | 极佳 | 需内核支持 |
| 配置难度 | 简单 | 中等 |
| 性能 | 优秀 | 优秀 |
| IPv6 支持 | 完善 | 完善 |
| 热点代理 | 支持 | 支持 |

### 启用 TPROXY 模式

**方法一：通过终端模拟器或 ADB Shell**

```bash
# 启动 TPROXY 模式
su -c "/data/adb/modules/Clash/Scripts/Clash.TProxy start"

# 停止 TPROXY 模式
su -c "/data/adb/modules/Clash/Scripts/Clash.TProxy stop"

# 重启 TPROXY 模式
su -c "/data/adb/modules/Clash/Scripts/Clash.TProxy restart"
```

**方法二：创建快捷命令**

在终端模拟器中添加以下别名（添加到 `.bashrc` 或 `.zshrc`）：

```bash
alias tproxy-start='su -c "/data/adb/modules/Clash/Scripts/Clash.TProxy start"'
alias tproxy-stop='su -c "/data/adb/modules/Clash/Scripts/Clash.TProxy stop"'
alias tproxy-restart='su -c "/data/adb/modules/Clash/Scripts/Clash.TProxy restart"'
```

### TPROXY 配置说明

1. **复制 TPROXY 配置示例**
   ```bash
   # 将 TPROXY 配置示例复制为主配置
   cp /sdcard/Android/Clash/TProxy配置示例.yaml /sdcard/Android/Clash/Clash配置.yaml
   ```

2. **修改 TProxy配置.txt（可选）**
   位于 `/sdcard/Android/Clash/TProxy配置.txt`，可配置：
   - `PROXY_TCP_PORT` - TCP 透明代理端口（默认 7893）
   - `PROXY_UDP_PORT` - UDP 透明代理端口（默认 7893）
   - `DNS_PORT` - DNS 监听端口（默认 1053）
   - `PROXY_IPV6` - 是否代理 IPv6 流量（1=启用，0=禁用）
   - `PROXY_TCP` - 是否代理 TCP 流量
   - `PROXY_UDP` - 是否代理 UDP 流量

3. **确保 Clash 配置正确**
   在 `Clash配置.yaml` 中需要配置：
   ```yaml
   # TPROXY 端口（与 TProxy配置.txt 保持一致）
   tproxy-port: 7893
   
   # TUN 模式需要禁用
   tun:
     enable: false
   
   # DNS 配置
   dns:
     enable: true
     listen: 0.0.0.0:1053
   ```

### 检查 TPROXY 支持

运行以下命令检查内核是否支持 TPROXY：

```bash
su -c "zcat /proc/config.gz | grep TPROXY"
```

如果输出包含 `CONFIG_NETFILTER_XT_TARGET_TPROXY=y` 或 `=m`，则表示支持。

---

## TUN 模式使用（默认）

TUN 模式是默认模式，无需额外配置。模块安装后自动使用 TUN 模式。

控制命令（与 Box4Magisk 一致）：

```bash
# 启动内核
su -c "/data/adb/modules/Clash/Scripts/Clash.Service start"

# 停止内核
su -c "/data/adb/modules/Clash/Scripts/Clash.Service stop"

# 重启内核
su -c "/data/adb/modules/Clash/Scripts/Clash.Service restart"
```

---

## 注意事项
1. **谨慎修改配置文件**  
   - `config.yaml` 文件中包含注释说明请注意阅读，请勿随意更改 `tun`、`sniffer` 等设置，以免出现问题。  
   - 如果配置出现问题，请到 `/内部存储/Android/Clash` 文件夹中查看默认配置备份，或者重新刷入模块。原有配置文件会被保留并重命名。

2. **手机开机后解锁后启动内核**  
   - 每次手机开机后需要解锁手机一次以解密 `data` 分区，内核才会启动。  
   - 如果未输入密码直接通过通知栏等方式开启热点，热点将无法被代理，使用随身WiFi用户请注意此项。

3. **TPROXY 模式注意事项**
   - TPROXY 需要内核支持，部分定制ROM可能不支持
   - 使用 TPROXY 前请先停止 TUN 模式
   - TPROXY 和 TUN 模式不能同时运行

---

## 使用小技巧
面板支持网页应用特性，在 Chrome 等浏览器中打开网页面板：[http://127.0.0.1:9090/ui](http://127.0.0.1:9090/ui)，点击右上角选项，选择 `添加到主屏幕` ，并选择 `安装` 可在桌面创建快捷方式，点击后即可全屏打开面板，且在内核未启动时也能打开面板，体验更好

---

## 文件结构

```
/data/adb/modules/Clash/
├── Scripts/
│   ├── Clash.Service      # TUN 模式控制脚本
│   ├── Clash.TProxy       # TPROXY 模式控制脚本
│   └── Clash.Inotify      # 模块开关监听脚本
├── Proxy/
│   ├── Clash.Core         # Clash Meta 内核
│   ├── config.yaml        # Clash 配置文件（软链接）
│   └── ...
└── ...

/sdcard/Android/Clash/
├── Clash配置.yaml         # Clash 主配置文件
├── TProxy配置.txt         # TPROXY 模式配置
├── TProxy配置示例.yaml    # TPROXY 模式配置示例
├── 内核日志.txt           # 内核运行日志
└── ...
```

---

## 致谢

- [Clash Meta](https://github.com/MetaCubeX/Clash.Meta) - 强大的代理内核
- [AndroidTProxyShell](https://github.com/CHIZI-0618/AndroidTProxyShell) - TPROXY 实现参考
- [Box4Magisk](https://github.com/FLAVOR/Box4Magisk) - 命令格式参考

更多特性 **is coming sooooooon**  敬请期待！
---
