#!/bin/bash

red=\033[0;31m
green=\033[0;32m
yellow=\033[0;33m
plain=\033[0m

[[ $EUID -ne 0 ]] && echo -e "${red}Fatal error: ${plain}Please run this script with root privilege." && exit 1

xui_folder="/usr/local/x-ui"

print_logo() {
    echo -e "${green}"
    echo "   ____       _               _     __  __ ____                   _ "
    echo "  / ___| __ _| | _____ &__  _| |   \ \/ /|  _ \ __ _ _ __   ___| |"
    echo " | |  _ / _` | |/ / _ \\ \/ / |____\  / | |_) / _` | '_ \ / _ \ |"
    echo " | |_| | (_| |   <  __/ >  <| |_____/  \ |  __/ (_| | | | |  __/ |"
    echo "  \____|\__,_|_|\_\___|/_/\_\_|    /_/\_\_|   \__,_|_| |_|\___|_|"
    echo -e "${plain}"
}

coloredEcho() {
    echo -e "${green}$1${plain}"
}

install_base() {
    coloredEcho "Updating packages and installing dependencies..."
    if command -v apt-get &>/dev/null; then
        apt-get update >/dev/null 2>&1
        apt-get install -y -q curl wget tar socat certbot >/dev/null 2>&1
    elif command -v dnf &>/dev/null; then
        dnf install -y -q curl wget tar socat certbot >/dev/null 2>&1
    elif command -v yum &>/dev/null; then
        yum install -y -q curl wget tar socat certbot >/dev/null 2>&1
    fi
}

install_x-ui() {
    print_logo
    install_base

    if [ -d "$xui_folder" ]; then
        systemctl stop x-ui 2>/dev/null
    fi

    mkdir -p $xui_folder
    cd $xui_folder

    coloredEcho "Downloading Galexy X Panel Release..."
    curl -fL -o x-ui-linux-amd64.tar.gz https://github.com/ksgamer31/galexy-x-panel/releases/download/v1.2.1/x-ui-linux-amd64.tar.gz
    if [ $? -ne 0 ]; then
        echo -e "${red}Download failed! Please check your release asset or network.${plain}"
        exit 1
    fi

    tar -xzf x-ui-linux-amd64.tar.gz
    if [ -d "x-ui" ] && [ ! -x "x-ui" ]; then
        mv x-ui/* .
        rmdir x-ui
    fi
    rm -f x-ui-linux-amd64.tar.gz

    chmod +x x-ui

    if [ -f "deploy/x-ui.service" ]; then
        cp deploy/x-ui.service /etc/systemd/system/x-ui.service
    else
        cat << EOF > /etc/systemd/system/x-ui.service
[Unit]
Description=Galexy X Panel
After=network.target

[Service]
Type=simple
ExecStart=${xui_folder}/x-ui
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
    fi

    systemctl daemon-reload
    systemctl enable x-ui
    systemctl restart x-ui

    coloredEcho "=== Galexy X Panel Installed Successfully! ==="
    coloredEcho "Access URL / Panel is ready."
}

install_x-ui
