#luci-app-dnspod

## 简介
在OpenWRT的LuCI上像使用DDNS一样使用[DNSPOD][dnspod]的服务.

forked from [ntlf9t/luci-app-dnspod][parent]
亦参考[honwen/luci-app-alidns][luci-app-alidns]

## 依赖
本软件包依赖`bash`和`curl`.

## 编译
从OpenWRT的[SDK][openwrt-sdk]编译
```bash
# 解压下载好的 SDK
tar xfv openwrt-sdk-19.07.3-x86-64_gcc-7.5.0_musl.Linux-x86_64.tar.xz
cd openwrt-sdk-19.07.3-x86-64_gcc-7.5.0_musl.Linux-x86_64
# Clone 项目
mkdir -p package/feeds
git clone https://github.com/samhjn/luci-app-dnspod.git package/feeds/luci-app-dnspod
# 安装po2lmo
# 现多语言支持不全，可手工修改Makefile跳过po2lmo的过程
# 选择要编译的包 LuCI -> 3. Applications
make menuconfig
# 开始编译
make package/feeds/luci-app-dnspod/compile V=s
```

## 已知问题
1. 应用配置以后无法自动拉起dnspod服务
2. IPv6支持欠佳，可能处于失效状态，相关设计需要重新梳理
3. i18n支持欠佳

[dnspod]: https://dnspod.cn
[parent]: https://github.com/ntlf9t/luci-app-dnspod
[luci-app-alidns]: https://github.com/honwen/luci-app-aliddns
[openwrt-sdk]: https://openwrt.org/docs/guide-developer/using_the_sdk
