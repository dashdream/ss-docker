###
 # @author: Haoran Qi
 # @Date: 2020-01-16 13:42
 # @LastEditors  : Haoran Qi
 # @LastEditTime : 2020-08-10 19:36
 # @FilePath     : \A3SPL\ss-docker\pi-setup-wifi.sh
 # @Description: TODO
 ###
#! /bin/bash

# Update 
sudo apt-get update

# Install requirements
sudo apt-get install -y hostapd dnsmasq bridge-utils ebtables

# Enable IP forwarding
sudo echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sudo sysctl -p

# Config dhcpcd
sudo bash -c "cat >>/etc/dhcpcd.conf <<EOF
#this line existes to make sure below starts in a new line
interface eth0

interface wlan0
static ip_address=192.168.3.1/24
nohook wpa_supplicant

interface eth1
static ip_address=192.168.4.1/24
nohook wpa_supplicant

EOF"
sudo systemctl restart dhcpcd

# Config dnsmasq
sudo bash -c "cat >>/etc/dnsmasq.conf <<EOF
#this line existes to make sure below starts in a new line
interface=wlan0
dhcp-range=192.168.3.200,192.168.3.230,255.255.255.0,24h

interface=eth1
dhcp-range=192.168.4.100,192.168.4.105,255.255.255.0,24h
EOF"

# Config hostapd
sudo bash -c "cat >/etc/hostapd/hostapd.conf <<EOF
interface=wlan0
driver=nl80211
hw_mode=a
ieee80211n=1
ieee80211ac=1
ieee80211d=1
ieee80211h=1
require_ht=1
require_vht=1
wmm_enabled=1
country_code=US
vht_oper_chwidth=1
channel=149
vht_oper_centr_freq_seg0_idx=155
ht_capab=[HT40-][HT40+][SHORT-GI-40][DSSS_CCK-40]
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
ssid=PI_WIFI
wpa_passphrase=Password=1
EOF"

# Config hostapd daemon
sudo echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" >> /etc/default/hostapd
sudo systemctl unmask hostapd
sudo systemctl start hostapd
sudo systemctl start dnsmasq
sudo systemctl enable hostapd
sudo systemctl enable dnsmasq
sudo systemctl enable dhcpcd

sudo bash -c "cat >>/etc/rc.local <<EOF
# 8443->22
iptables -t nat -A PREROUTING -p tcp --dport 8443 -j REDIRECT --to-ports 22
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

exit 0
EOF"

sudo /etc/rc.local
# sudo reboot
echo -e "Confirm /etc/rc.local with only one exit0"
