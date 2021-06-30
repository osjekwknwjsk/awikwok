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
mkdir -p /etc/trojan-go-mini/
touch /etc/trojan-go-mini/akun.conf

# Installing Trojan Go
mkdir -p /etc/trojan-go-mini/
chmod 755 /etc/trojan-go-mini/
touch /etc/trojan-go-mini/trojan-go.pid
wget -O /usr/bin/trojan-go-mini https://wildyproject.net/Script/trojan-go/trojan-go
wget -O /usr/bin/geoip.dat https://wildyproject.net/Script/trojan-go/geoip.dat
wget -O /usr/bin/geosite.dat https://wildyproject.net/Script/trojan-go/geosite.dat
chmod +x /usr/bin/trojan-go-mini

# Service
mkdir /var/log/trojan-go
cat > /etc/systemd/system/trojan-go-mini.service << END
[Unit]
Description=Trojan-Go Mini Service
Documentation=https://p4gefau1t.github.io/trojan-go/
Documentation=https://github.com/trojan-gfw/trojan
After=network.target

[Service]
Type=simple
PIDFile=/etc/trojan-go-mini/trojan-go.pid
ExecStart=/usr/bin/trojan-go-mini -config /etc/trojan-go-mini/config.json
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartSec=10
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
END

# Config
cat > /etc/trojan-go-mini/config.json << END
{
  "run_type": "server",
  "local_addr": "0.0.0.0",
  "local_port": 666,
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

# Starting
systemctl daemon-reload
systemctl enable trojan-go-mini
systemctl start trojan-go-mini


#path cert /etc/v2ray/v2ray.crt
