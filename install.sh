#!/bin/bash

red=\033[0;31m
green=\033[0;32m
yellow=\033[0;33m
plain=\033[0m

[[ $EUID -ne 0 ]] && echo -e "${red}Fatal error: ${plain}Please run this script with root privilege." && exit 1

xui_folder="/usr/local/x-ui"

echo -e "${green}=== Installing GALEXY X PANEL ===${plain}"

# Install dependencies silently
apt-get update > /dev/null 2>&1
apt-get install -y -q curl wget tar socat tzdata openssl > /dev/null 2>&1

mkdir -p ${xui_folder}
cd ${xui_folder}

echo -e "${green}Downloading Galexy X Panel release...${plain}"
# Download master or release directly without API check
curl -fL -o x-ui-linux-amd64.tar.gz https://github.com/ksgamer31/galexy-x-panel/archive/refs/heads/main.tar.gz
if [ $? -ne 0 ]; then
    echo -e "${red}Download failed! Please check your network connection.${plain}"
    exit 1
fi

tar -xzf x-ui-linux-amd64.tar.gz --strip-components=1
rm -f x-ui-linux-amd64.tar.gz

chmod +x x-ui
if [ -f "x-ui.sh" ]; then
    chmod +x x-ui.sh
fi

if [ -f "x-ui.service.debian" ]; then
    cp x-ui.service.debian /etc/systemd/system/x-ui.service
elif [ -f "deploy/x-ui.service" ]; then
    cp deploy/x-ui.service /etc/systemd/system/x-ui.service
fi

systemctl daemon-reload
systemctl enable x-ui
systemctl restart x-ui

echo -e "${green}=== GALEXY X PANEL Installed Successfully! ===${plain}"
