#!/bin/bash

# Installing Wget & Curl
apt update -y
apt upgrade -y
apt install wget -y
apt install screen -y
apt install curl -y
apt install zip

# Domain 
domain=$(cat /root/domain)

# Uuid Service
uuid=$(cat /proc/sys/kernel/random/uuid)

# Trojan Go Akun 
mkdir -p /etc/trojan-go-william/
touch /etc/trojan-go-william/akun.conf

# Installing Trojan Go
mkdir -p /etc/trojan-go-william/
chmod 755 /etc/trojan-go-william/
touch /etc/trojan-go-william/trojan-go.pid
wget -O /usr/bin/trojan-go-william https://raw.githubusercontent.com/xkjdox/zmndjekw/main/trojan-go
wget -O /usr/bin/geoip.dat https://raw.githubusercontent.com/xkjdox/zmndjekw/main/geoip.dat
wget -O /usr/bin/geosite.dat https://raw.githubusercontent.com/xkjdox/zmndjekw/main/geosite.dat
chmod +x /usr/bin/trojan-go-william

# Service
mkdir /var/log/trojan-go
cat > "/etc/systemd/system/trojan-go-william.service" << EOF
[Unit]
Description=trojan-go
After=network.target network-online.target nss-lookup.target mysql.service mariadb.service mysqld.service
[Service]
Type=simple
StandardError=journal
ExecStart="/usr/bin/trojan-go-william" -config "/etc/trojan-go-william/config.json"
ExecReload=/bin/kill -HUP $MAINPID
LimitNOFILE=51200
Restart=on-failure
RestartSec=1s
[Install]
WantedBy=multi-user.target
EOF

# Config
cat > /etc/trojan-go-william/config.json << END
{
  "run_type": "server",
  "local_addr": "0.0.0.0",
  "local_port": 2096,
  "remote_addr": "127.0.0.1",
  "remote_port": 81,
  "log_level": 1,
  "log_file": "/var/log/trojan-go.log",
  "password": [
        "$uuid"
        "$uuid"
        ""
  ],
  "disable_http_check": false,
  "udp_timeout": 60,
  "ssl": {
    "verify": true,
    "verify_hostname": true,
    "cert": "/etc/v2ray/v2ray.crt",
    "key": "/etc/v2ray/v2ray.key",
    "key_password": "",
    "cipher": "",
    "curves": "",
    "prefer_server_cipher": false,
    "sni": "$domain",
    "alpn": [
      "h2"
    ],
    "session_ticket": true,
    "reuse_session": true,
    "plain_http_response": "",
    "fallback_addr": "",
    "fallback_port": 0,
    "fingerprint": "firefox"
  },
  "tcp": {
    "no_delay": true,
    "keep_alive": true,
    "prefer_ipv4": true
  },
  "mux": {
    "enabled": true,
    "concurrency": 64,
    "idle_timeout": 60
  },
  "router": {
    "enabled": false,
    "bypass": [],
    "proxy": [],
    "block": [],
    "default_policy": "proxy",
    "domain_strategy": "as_is",
    "geoip": "/usr/bin/geoip.dat",
    "geosite": "/usr/bin/geosite.dat"
  },
  "websocket": {
    "enabled": true,
    "path": "/trojango",
    "host": "$domain"
  },
  "shadowsocks": {
    "enabled": false,
    "method": "AES-128-GCM",
    "password": ""
  },
  "transport_plugin": {
    "enabled": false,
    "type": "",
    "command": "",
    "plugin_option": "",
    "arg": [],
    "env": []
  },
  "forward_proxy": {
    "enabled": false,
    "proxy_addr": "",
    "proxy_port": 0,
    "username": "",
    "password": ""
  },
  "mysql": {
    "enabled": false,
    "server_addr": "localhost",
    "server_port": 3306,
    "database": "",
    "username": "",
    "password": "",
    "check_rate": 60
  },
  "api": {
    "enabled": false,
    "api_addr": "",
    "api_port": 0,
    "ssl": {
      "enabled": false,
      "key": "",
      "cert": "",
      "verify_client": false,
      "client_cert": []
    }
  }
}
END

#Allow Port

# Starting
systemctl daemon-reload
systemctl enable trojan-go-william
systemctl start trojan-go-william


#path cert /etc/v2ray/v2ray.crt
