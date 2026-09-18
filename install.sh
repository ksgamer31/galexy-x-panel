#!/bin/bash

# Galexy X Panel - Official Installation Script
XUI_FOLDER="/usr/local/x-ui"
SERVICE_FILE="/etc/systemd/system/x-ui.service"

echo "=== Installing Galexy X Panel (Official) ==="

# Install dependencies
apt-get update && apt-get install -y curl tar

# Stop and cleanup
systemctl stop x-ui 2>/dev/null
rm -rf ${XUI_FOLDER}

mkdir -p ${XUI_FOLDER}
cd ${XUI_FOLDER}

# Download binary release
echo "Downloading Galexy X Panel Release..."
curl -L -o x-ui-linux-amd64.tar.gz https://github.com/ksgamer31/galexy-x-panel/releases/download/v1.2.1/x-ui-linux-amd64.tar.gz

tar -xzf x-ui-linux-amd64.tar.gz
# If tar contained a nested folder, move it up
if [ -d "x-ui" ] && [ ! -x "x-ui" ]; then
    mv x-ui/* .
    rmdir x-ui
fi
rm -f x-ui-linux-amd64.tar.gz

chmod +x x-ui

# Setup systemd service
cat << EOF > ${SERVICE_FILE}
[Unit]
Description=Galexy X Panel
After=network.target

[Service]
Type=simple
ExecStart=${XUI_FOLDER}/x-ui
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable x-ui
systemctl start x-ui

echo "=== Galexy X Panel Installed Successfully! ==="
