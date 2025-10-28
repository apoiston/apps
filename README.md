
# feeds

## A. 从软件源安装（推荐）

```shell
wget -qO- https://infinityapps.pages.dev/feed.sh | ash
```

**提示**：推荐此方式，只需运行一次，后续可以通过 upgrade 升级。

## B. 从发布版本安装

```shell
wget -qO- https://infinityapps.pages.dev/install.sh | ash
```

## 插件信息

1. [Nikki](https://github.com/nikkinikki-org/OpenWrt-nikki) : **[nikki luci-app-nikki luci-i18n-nikki-zh-cn]**

2. [nikki-geodata](https://github.com/apoiston/nikki-geodata) : **[nikki-geodata]**

```shell
# for apk
apk add nikki luci-app-nikki luci-i18n-nikki-zh-cn nikki-geodata
# for opkg
opkg install nikki luci-app-nikki luci-i18n-nikki-zh-cn nikki-geodata
```
**提示**：nikki-geodata (GeoIP, Geosite, ASN, Country)为可选包，使用 ruleset 无需安装 nikki-geodata

### 特别感谢

- [@Joseph Mory](http://github.com/morytyann)
