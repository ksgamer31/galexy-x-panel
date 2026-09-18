#!/bin/bash
red="\033[0;31m"
green="\033[0;32m"
plain="\033[0m"

[[ $EUID -ne 0 ]] && echo -e "${red}Please run as root${plain}" && exit 1

echo -e "${green}=== Installing Galexy X Panel ===${plain}"
apt-get update && apt-get install -y curl wget tar socat

mkdir -p /usr/local/x-ui
cd /usr/local/x-ui

echo -e "${green}Downloading source package...${plain}"
curl -L -o x-ui.tar.gz https://github.com/ksgamer31/galexy-x-panel/archive/refs/heads/main.tar.gz
tar -xzf x-ui.tar.gz --strip-components=1
rm -f x-ui.tar.gz

if [ -f "deploy/x-ui.service" ]; then
    cp deploy/x-ui.service /etc/systemd/system/x-ui.service
fi

systemctl daemon-reload
systemctl enable x-ui
systemctl restart x-ui

echo -e "${green}=== Galexy X Panel Installed Successfully! ===${plain}"
