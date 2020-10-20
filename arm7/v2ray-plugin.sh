###
 # @author       : Haoran Qi
 # @Date         : 1970-01-01 08:00
 # @LastEditors  : Haoran Qi
 # @LastEditTime : 2020-09-26 16:10
 # @FilePath     : /ss-docker/arm7/v2ray-plugin.sh
 # @Copyright 2020 Haoran Qi
 # @Description  : ---
### 
#!/bin/sh
#
# This is a Shell script for shadowsocks-libev based alpine with Docker image
# 
# Copyright (C) 2019 - 2020 format
#
# Reference URL:
# https://github.com/shadowsocks/shadowsocks-libev
# https://github.com/shadowsocks/simple-obfs
# https://github.com/shadowsocks/v2ray-plugin

ARCH="arm7"

[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1
# Download v2ray-plugin binary file
V2RAY_PLUGIN_FILE="v2ray-plugin_linux_${ARCH}"
echo "Downloading v2ray-plugin binary file: ${V2RAY_PLUGIN_FILE}"
wget -O /usr/bin/v2ray-plugin https://dl.lamp.sh/files/${V2RAY_PLUGIN_FILE} > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to download v2ray-plugin binary file: ${V2RAY_PLUGIN_FILE}" && exit 1
fi
chmod +x /usr/bin/v2ray-plugin
echo "Download v2ray-plugin binary file: ${V2RAY_PLUGIN_FILE} completed"