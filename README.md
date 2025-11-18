
# feeds

## A. 从软件源安装（推荐）

```shell
wget -q -O- https://infinityapps.pages.dev/feed.sh | ash
```

## B. 从发布版本安装

```shell
wget -q -O- https://infinityapps.pages.dev/install.sh | ash
```

## 插件信息

1. [Nikki](https://github.com/nikkinikki-org/OpenWrt-nikki) : **nikki luci-app-nikki luci-i18n-nikki-zh-cn**

2. [nikki-geodata](https://github.com/apoiston/nikki-geodata) : **nikki-geodata**

```shell
# for apk
apk add nikki luci-app-nikki luci-i18n-nikki-zh-cn
```
```shell
# for opkg
opkg install nikki luci-app-nikki luci-i18n-nikki-zh-cn
```

### 特别感谢

- [@Joseph Mory](http://github.com/morytyann)
