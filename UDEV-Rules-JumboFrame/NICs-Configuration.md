# NICs-Configuration.md

* Fixed `udev` rules, that are loaded during the boot-process & a static IP save a lot of troubles & disappointments in Home-Lab.
* These instructions are specifically for 10Gbps NICs, also called "Jumbo Frame", but, as always, you can customize them to your own needs.

## 1. "UDEV" Rules
1. **Create the configuration file:**
```bash
sudo nano /etc/udev/rules.d/10-intel-x710.rules
```

2. **Example of your file:**
```bash
# 10-intel-x710.rules - Forced 10G and Jumbo Frames

ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp10s0f0np0", RUN+="/usr/bin/ip link set %k up mtu 9000 txqueuelen 10000", RUN+="/usr/bin/ethtool -s %k speed 10000 duplex full autoneg off"

ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp10s0f1np1", RUN+="/usr/bin/ip link set %k up mtu 9000 txqueuelen 10000", RUN+="/usr/bin/ethtool -s %k speed 10000 duplex full autoneg off"
# This's a comment & at same time is ignored anyway. you can decide to let this comment or make your own or let an empty one.
```
* ***Note:*** Linux ignore last line of configuration file or script, hence, you can let this or other comment or let anyway an emtpy line at end.

---

* **Recommendation:** Complete the basics settings for your home-lab assigning a static IP like under [this link](tree/main/Assign-Static-IP/) explained & scripted.

---

✅ **Done** 👍 & enjoy 🪅❗️ 





