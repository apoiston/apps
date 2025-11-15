#!/bin/sh

# Nikki's installer

# include openwrt_release
. /etc/openwrt_release

# check env
if { [ ! -x "/bin/opkg" ] && [ ! -x "/usr/bin/apk" ]; } || [ ! -x "/sbin/fw4" ]; then
    echo "supports only systems with opkg or apk and firewall4"
    exit 1
fi

if [ "$DISTRIB_ARCH" != "x86_64" ]; then
    echo "supports only x86_64 architecture"
    exit 1
fi

# get branch/arch
arch="$DISTRIB_ARCH"
branch=
case "$DISTRIB_RELEASE" in
    *"24.10"*)
        branch="openwrt-24.10"
        ;;
    "SNAPSHOT")
        branch="SNAPSHOT"
        ;;
    *)
        echo "unsupported release: $DISTRIB_RELEASE"
        exit 1
        ;;
esac

# feed url
repository_url="https://infinityapps.pages.dev"
# if ! wget --spider --timeout=5 --tries=1 "$repository_url" >/dev/null 2>&1; then
#     repository_url="https://apoiston.github.io/apps"
# fi
feed_url="$repository_url/$branch/$arch/apps"

# get versions
eval $(wget -q -O- "$feed_url/index.json" | jsonfilter -e 'version=@["packages"]["nikki"]' -e 'app_version=@["packages"]["luci-app-nikki"]' -e 'i18n_version=@["packages"]["luci-i18n-nikki-zh-cn"]')

# install packages
case "$(command -v opkg || command -v apk)" in
    */opkg)
        # download ipks
        wget -q -O "nikki_${version}_${arch}.ipk" "$feed_url/nikki_${version}_${arch}.ipk"
        wget -q -O "luci-app-nikki_${app_version}_all.ipk" "$feed_url/luci-app-nikki_${app_version}_all.ipk"
        wget -q -O "luci-i18n-nikki-zh-cn_${i18n_version}_all.ipk" "$feed_url/luci-i18n-nikki-zh-cn_${i18n_version}_all.ipk"

        # update feeds
        echo "update feeds"
        opkg update

        # install ipks
        echo "install ipks"
        opkg install nikki_*.ipk luci-app-nikki_*.ipk luci-i18n-nikki-zh-cn_*.ipk
        rm -f -- *nikki*.ipk
        ;;
    */apk)
        # add key
        echo "add key"
        public_key_file="/etc/apk/keys/infinityapps.pem"
        wget -q -O "$public_key_file" "$repository_url/public-key.pem"

        # install apks from remote repository
        echo "install apks from remote repository"
        apk add -X $feed_url/packages.adb nikki luci-app-nikki luci-i18n-nikki-zh-cn
        
        # remove key
        echo "remove key"
        rm -f /etc/apk/keys/infinityapps.pem
        ;;
esac

echo "Success"

exit 0
