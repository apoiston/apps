#!/bin/sh

# Nikki's feed

# include openwrt_release
. /etc/openwrt_release

# check arch & branch
echo "arch: $DISTRIB_ARCH"
echo "branch: $DISTRIB_RELEASE"

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
branch=""
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

case "$(command -v opkg || command -v apk)" in
    */opkg)
        # add key
        echo "add key"
        key_build_pub_file="key-build.pub"
        wget -q -O "$key_build_pub_file" "$repository_url/key-build.pub"
        opkg-key add "$key_build_pub_file"
        rm -f "$key_build_pub_file"

        # add feed
        echo "add feed"
        if grep -q -e nikki -e infinityapps /etc/opkg/customfeeds.conf; then
            sed -i '/nikki\|infinityapps/d' /etc/opkg/customfeeds.conf
        fi
        echo "src/gz infinityapps $feed_url" >> /etc/opkg/customfeeds.conf

        # update feeds
        echo "update feeds"
        opkg update

        # install nikki
        echo "install nikki"
        opkg install nikki luci-app-nikki luci-i18n-nikki-zh-cn
        ;;
    */apk)
        # add key
        echo "add key"
        public_key_file="/etc/apk/keys/infinityapps.pem"
        wget -q -O "$public_key_file" "$repository_url/public-key.pem"

        # add feed
        echo "add feed"
        if grep -q -e nikki -e infinityapps /etc/apk/repositories.d/customfeeds.list; then
            sed -i '/nikki\|infinityapps/d' /etc/apk/repositories.d/customfeeds.list
        fi
        echo "$feed_url/packages.adb" >> /etc/apk/repositories.d/customfeeds.list

        # update feeds
        echo "update feeds"
        apk update

        # install nikki
        echo "install nikki"
        apk add nikki luci-app-nikki luci-i18n-nikki-zh-cn
        ;;
esac

echo "Success"

exit 0
