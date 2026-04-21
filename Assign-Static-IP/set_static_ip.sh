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
# Set Admin Port (D8)
sudo nmcli con add type ethernet con-name "Admin-Port-1" ifname enp65s0f0np0 \
    ipv4.method manual ipv4.addresses 192.168.1.20/24 ipv4.gateway 192.168.1.1 \
    ipv4.dns "1.1.1.1"

# Set VM Bridge Port (D9)
sudo nmcli con add type ethernet con-name "VM-Bridge-Port" ifname enp65s0f1np1 \
    ipv4.method disabled ipv6.method disabled

# --- 3. Finalize ---
sudo nmcli connection up "Admin-Port-1"
sudo nmcli connection up "VM-Bridge-Port"
sudo systemctl restart NetworkManager

echo "Verification:"
ip -4 addr show | grep -E "enp65s0f0np0|enp65s0f1np1"
