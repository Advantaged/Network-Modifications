# UDEV-Rules-JumboFrame.md

* Fixed `udev` rules, that are loaded during the boot-process & a static IP save a lot of troubles & disappointments in Home-Lab.
* These instructions are specifically for 10Gbps NICs, also called "Jumbo Frame", but, as always, you can customize them to your own needs.

## 1. "UDEV" Rules
1. **Create the configuration file:**
```bash
sudo nano /etc/udev/rules.d/10-intel-x710.rules
```

2. **Example of your file:**
```bash
# 10-intel-x710.rules- Forced 10G and Jumbo Frames

# Intel X710-DA2 (SFP+ Ports)
ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp10s0f0np0", RUN+="/usr/bin/ip link set %k up mtu 9000 txqueuelen 10000", RUN+="/usr/bin/ethtool -s %k speed 10000 duplex full autoneg off"
ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp10s0f1np1", RUN+="/usr/bin/ip link set %k up mtu 9000 txqueuelen 10000", RUN+="/usr/bin/ethtool -s %k speed 10000 duplex full autoneg off"

# Intel X710-T4L (RJ45 Ports)
ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp65s0f0np0", RUN+="/usr/bin/ip link set %k up mtu 9000 txqueuelen 10000", RUN+="/usr/bin/ethtool -s %k speed 10000 duplex full autoneg off"
ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp65s0f1np1", RUN+="/usr/bin/ip link set %k up mtu 9000 txqueuelen 10000", RUN+="/usr/bin/ethtool -s %k speed 10000 duplex full autoneg off"
ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp65s0f2np2", RUN+="/usr/bin/ip link set %k up mtu 9000 txqueuelen 10000", RUN+="/usr/bin/ethtool -s %k speed 10000 duplex full autoneg off"
ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp65s0f3np3", RUN+="/usr/bin/ip link set %k up mtu 9000 txqueuelen 10000", RUN+="/usr/bin/ethtool -s %k speed 10000 duplex full autoneg off"
# This's a comment & at same time is ignored anyway. you can decide to let this comment in or make your own or let an empty line.
```
* ***Notes:***
 *  Linux ignore last line of configuration files or scripts, hence, you can let this in or set other comment or let anyway an empty line at end.
 *  For clarity and/or visibility, you can use wild cards, such as e.g. `enp10s0f*` and/or `enp65s0f*` in the configuration file reducing the the whole to only two commands for six (6) ports.

* **Example:**
```bash
# 10-intel-x710.rules- Forced 10G and Jumbo Frames

# Intel X710-DA2 (2x SFP+ Ports)
ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp10s0f*", RUN+="/usr/bin/ip link set %k up mtu 9000 txqueuelen 10000", RUN+="/usr/bin/ethtool -s %k speed 10000 duplex full autoneg off"

# Intel X710-T4L (4x RJ45 Ports)
ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp65s0f*", RUN+="/usr/bin/ip link set %k up mtu 9000 txqueuelen 10000", RUN+="/usr/bin/ethtool -s %k speed 10000 duplex full autoneg off"

```

3. **Reload & Trigger Rules:**
```bash
sudo udevadm control --reload-rules && sudo udevadm trigger
```
---

* **Recommendation:** Complete the basics settings for your home-lab assigning a static IP following [correlated link](https://github.com/Advantaged/Network-Modifications/tree/main/Assign-Static-IP) with explainations & script.

---

✅ **Done** 👍 & enjoy 🪅❗️ 





