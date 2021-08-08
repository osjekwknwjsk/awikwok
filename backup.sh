#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
IZIN=$( curl https://raw.githubusercontent.com/xkjdox/rijrekeksdpdolwoqkqkakodix/main/Nxbdjekkwso.txt | grep $MYIP )
if [ $MYIP = $IZIN ]; then
echo -e "${green}Permission Accepted${NC}"
else
echo -e "${red}Permission Denied!${NC}";
echo "Only For Premium Users"
exit 0
fi
IP=$(wget -qO- ipinfo.io/ip);
date=$(date +"%Y-%m-%d")
clear
echo " Enter Your Email To Receive Message"
read -rp " Email: " -e email
sleep 1
echo Membuat Directory
mkdir /root/backup
sleep 1
echo Start Backup
clear
cp /etc/passwd backup/
cp /etc/group backup/
cp /etc/shadow backup/
cp /etc/gshadow backup/
cp -r /etc/wireguard backup/wireguard
cp /etc/ppp/chap-secrets backup/chap-secrets
cp /etc/ipsec.d/passwd backup/passwd1
cp /etc/shadowsocks-libev/akun.conf backup/ss.conf
cp -r /var/lib/premium-script/ backup/premium-script
cp -r /home/sstp backup/sstp
cp -r /etc/v2ray backup/v2ray
cp -r /etc/trojan backup/trojan
cp -r /etc/trojan-go backup/trojan-go
cp -r /usr/local/shadowsocksr/ backup/shadowsocksr
cp -r /home/vps/public_html backup/public_html
cd /root
zip -r $IP-$date.zip backup > /dev/null 2>&1
rclone copy /root/$IP-$date.zip william:backup/
url=$(rclone link william:backup/$IP-$date.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"
echo -e "Berikut ini adalah link file backup data vps anda.

IP VPS $IP

$link

Jika Ingin Merestore Data Harap Masukkan Link Diatas.

Terimakasih Telah Menggunakan Layanan Kami" | mail -s "Backup Data" $email
rm -rf /root/backup
rm -r /root/$IP-$date.zip
echo "Done"
echo "Please Check Your Email"
