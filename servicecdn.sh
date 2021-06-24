#!/bin/bash

mkdir -p /etc/william/
wget -q -O /etc/william/PDirect.py https://raw.githubusercontent.com/kepo/sojsiws/main/PDirect.py
chmod +x /etc/william/PDirect.py

cat > /etc/systemd/system/edu-proxy.service << END 
[Unit]
Description=Python Edu Proxy Service
Documentation=https://wildyproject.net
Documentation=https://wildyscript.my.id
Documentation=https://t.me/wildyproject
Documentation=https://github.com/PANCHO7532
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
NoNewPrivileges=true
ExecStart=/usr/bin/python /etc/william/PDirect.py 2053 /etc/william/PDirect.py 2052
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl enable edu-proxy
systemctl start edu-proxy