#!/bin/bash
# Title: stat-pres-fc.sh
# Merit to: Gemini AI & Advantaged
# Description: Configures a static IP for Admin Host, disables IP for VM Bridge preserving former NIC configuration.

# --- 1. Preparation ---
sudo -v
#echo "Cleaning old 'Wired connection' profiles..."
#for uuid in $(nmcli -g UUID,NAME con show | grep "Wired connection" | cut -d: -f1); do
#    sudo nmcli connection delete uuid "$uuid"
#done

# --- 2. Configuration ---
# Set Admin Port (D8)
sudo nmcli con add type ethernet con-name "Admin-JF-P1" ifname enp10s0f0np0 \
    ipv4.method manual ipv4.addresses 192.168.1.2/24 ipv4.gateway 192.168.1.1 \
    ipv4.dns "1.1.1.1"

# Set VM Bridge Port (D9)
sudo nmcli con add type ethernet con-name "VMM-JF-Bridge" ifname enp10s0f1np1 \
    ipv4.method disabled ipv6.method disabled

# --- 3. Finalize ---
sudo nmcli connection up "Admin-JF-P1"
sudo nmcli connection up "VMM-JF-Bridge"
sudo systemctl restart NetworkManager

echo "Verification:"
ip -4 addr show | grep -E "enp10s0f0np0|enp10s0f1np1"
# ---Script end---
