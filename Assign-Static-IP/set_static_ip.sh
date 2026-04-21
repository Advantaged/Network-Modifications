#!/bin/bash
# Title: set_static_ip.sh
# Merit to: Gemini AI & Arny007
# Description: Configures a static IP for Admin Host and disables IP for VM Bridge.

# --- 1. Preparation ---
sudo -v
echo "Cleaning old 'Wired connection' profiles..."
for uuid in $(nmcli -g UUID,NAME con show | grep "Wired connection" | cut -d: -f1); do
    sudo nmcli connection delete uuid "$uuid"
done

# --- 2. Configuration ---
# Set Admin Port with MAC-address ending in (`D8`)
# Edit here the con-name (normally called only 'Wired Connection 1'),
# the port-name (ifname) you get with command `ip a`,
# the IPv4 & the gateway according to your modem/router &
# DNS-address you like, i use one open (non restrictive) DNS server.
sudo nmcli con add type ethernet con-name "Admin-Port-1" ifname enp65s0f0np0 \
    ipv4.method manual ipv4.addresses 192.168.1.20/24 ipv4.gateway 192.168.1.1 \
    ipv4.dns "1.1.1.1"

# Set VM Bridge Port with MAC-address ending in (`D9`)
# Comment out with an hash (`#`) on front of following two lines if you want only a static IP.
sudo nmcli con add type ethernet con-name "VM-Bridge-Port" ifname enp65s0f1np1 \
    ipv4.method disabled ipv6.method disabled

# --- 3. Finalize ---
# Comment out with an hash (`#`) on front of "VM-Bridge-Port" line if you set only a static IP.
sudo nmcli connection up "Admin-Port-1"
sudo nmcli connection up "VM-Bridge-Port"
sudo systemctl restart NetworkManager

# Edit the name of your NIC-port.
# In case you assign only a static IP & don't have a bridge, delete the second name.
echo "Verification:"
ip -4 addr show | grep -E "enp65s0f0np0|enp65s0f1np1"
