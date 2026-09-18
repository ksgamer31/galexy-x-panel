#!/bin/bash
XUI_FOLDER="/usr/local/x-ui"
echo "Starting Installation..."
mkdir -p $XUI_FOLDER
cd $XUI_FOLDER
curl -fL -o x-ui-linux-amd64.tar.gz https://github.com/ksgamer31/galexy-x-panel/releases/download/v1.2.1/x-ui-linux-amd64.tar.gz
tar -xzf x-ui-linux-amd64.tar.gz
# Handle if it extracts to a folder
if [ -d "x-ui" ]; then
    mv x-ui/* .
    rmdir x-ui
fi
rm -f x-ui-linux-amd64.tar.gz
chmod +x x-ui
cat << EOF > /etc/systemd/system/x-ui.service
[Unit]
Description=Galexy X Panel
After=network.target
[Service]
Type=simple
ExecStart=${XUI_FOLDER}/x-ui
Restart=always
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable x-ui
systemctl restart x-ui
echo "Galexy X Panel Installed Successfully!"
