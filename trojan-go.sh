#!/usr/bin/env bash
# Wiki: https://github.com/p4gefau1t/trojan-go

# Install Trojan-GO
wget -O /usr/local/bin/trojan-go-william https://raw.githubusercontent.com/xkjdox/zmndjekw/main/trojan-go
chmod +x /usr/local/bin/trojan-go-william
mkdir -p "/etc/trojan-go/"
touch /etc/trojan-go/akun.conf
touch /etc/trojan-go/trojan-go.pid
mkdir /var/log/trojan-go/
uuid=$(cat /proc/sys/kernel/random/uuid)

cat > "/etc/systemd/system/trojan-go.service" << EOF
[Unit]
Description=Trojan-Go - An unidentifiable mechanism that helps you bypass GFW
Documentation=https://p4gefau1t.github.io/trojan-go/
After=network.target nss-lookup.target

[Service]
User=root
NoNewPrivileges=true
ExecStart=/usr/local/bin/trojan-go-william -config /etc/trojan-go/server.json
Restart=on-failure
RestartSec=10s
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/trojan-go/server.json << EOF
{
  "run_type": "server",
  "local_addr": "0.0.0.0",
  "local_port": 2096,
  "remote_addr": "127.0.0.1",
  "remote_port": 81,
  "log_level": 1,
  "log_file": "/var/log/trojan-go/trojan-go.log",
  "password": [
    "$uuid",
    "$uuid",
    ""
  ],
  "ssl": {
    "cert": "/etc/v2ray/v2ray.crt",
    "key": "/etc/v2ray/v2ray.key"
  },
  "websocket": {
    "enabled": true,
    "path": "/trojangowilliam"
  }
}
EOF

systemctl enable trojan-go.service && systemctl daemon-reload && systemctl start trojan-go.service && systemctl status trojan-go.service