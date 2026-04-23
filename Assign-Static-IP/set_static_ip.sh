#!/bin/bash
# Title: set_static_ip.sh
# Merit to: Gemini AI & Advantaged
# Description: Configures a static IP for Admin Host and disables IP for VM Bridge.
# Edit general: Never delete the double quotation ("term") befor & after a term.
# Editable terms: `con-name` at your choice. MAC-address, `ifname`, `ipv4` & `gateway` according
# to output of command `ip a`. As 'ipv4.dns` use the specified open or one of your choice.

# --- 1. Preparation ---
sudo -v
echo "Cleaning old 'Wired connection' profiles..."
for uuid in $(nmcli -g UUID,NAME con show | grep "Wired connection" | cut -d: -f1); do
    sudo nmcli connection delete uuid "$uuid"
done

# --- 2. Configuration ---
# Set Admin Port with MAC-address ending in `D8` (in my case) plus
# correlated `con-name`, `ifname`, `ipv4.addresses`, `ipv4.gateway` & `ipv4.dns`.
sudo nmcli con add type ethernet con-name "Admin-Port-1" ifname enp65s0f0np0 \
    ipv4.method manual ipv4.addresses 192.168.1.20/24 ipv4.gateway 192.168.1.1 \
    ipv4.dns "1.1.1.1"

# Set VM Bridge Port with MAC-address ending in (`D9`)
# Comment out with an hash (`#`) on front of following two lines if you want only a static IP.
sudo nmcli con add type ethernet con-name "VM-Bridge-Port" ifname enp65s0f1np1 \
    ipv4.method disabled ipv6.method disabled

# --- 3. Finalize ---
# Comment out with an hash (`#`) on front of "VM-Bridge-Port" line if you set only a static IP.
# Never comment out the (first) line containing "Admin-Port-1" or any name you given.
sudo nmcli connection up "Admin-Port-1"
sudo nmcli connection up "VM-Bridge-Port"
sudo systemctl restart NetworkManager

# Verify/check your Settings.
# In case you assign only a static IP & don't have a bridge,
# delete the second name & the separation sign `|enp65s0f1np1`.
echo "Verification:"
ip -4 addr show | grep -E "enp65s0f0np0|enp65s0f1np1"
