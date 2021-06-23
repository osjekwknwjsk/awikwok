#!/bin/bash
# Installing Service

mkdir -p /etc/william/
wget -q -O /etc/william/PDirect.py https://raw.githubusercontent.com/osjekwknwjsk/awikwok/main/PDirect.py
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
ExecStart=python /etc/william/PDirect.py 2082
Restart=on-failure

[Install]
WantedBy=multi-user.target
END
