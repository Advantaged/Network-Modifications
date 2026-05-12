#!/bin/bash
# Description: ISO 9001 Professional Networking Config, the NetworkManager

# 1. Configure the 2x DA2 (10G) - Metric 10 (Priority)
for i in {0..1}; do
  NAME="DA2-Port-$i"
  IFACE="enp10s0f${i}np${i}"
  sudo nmcli con delete "$NAME" 2>/dev/null
  sudo nmcli con add type ethernet con-name "$NAME" ifname "$IFACE" \
    802-3-ethernet.mtu 9000 ipv4.route-metric 10 ipv4.method manual \
    ipv4.addresses 192.168.1.$((2 + i))/24 ipv4.gateway 192.168.1.1 ipv4.dns "1.1.1.1"
done

# 2. Configure the 4x TL4 (1G/10G) - Metric 100 (Backup)
for i in {0..3}; do
  NAME="TL4-Port-$i"
  IFACE="enp65s0f${i}np${i}"
  sudo nmcli con delete "$NAME" 2>/dev/null
  sudo nmcli con add type ethernet con-name "$NAME" ifname "$IFACE" \
    802-3-ethernet.mtu 9000 ipv4.route-metric 100 ipv4.method manual \
    ipv4.addresses 192.168.1.$((20 + i))/24 ipv4.gateway 192.168.1.1 ipv4.dns "1.1.1.1"
done

sudo systemctl restart NetworkManager
# --- Script end --- ignored line
