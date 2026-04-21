# Network-Modifications
This project documents the transition of a production home network to a managed infrastructure.

## Subfolder: Assign-Static-IP
### Purpose
To ensure the Admin machine always resides at the IP-address ending in `.20` and keeps Port with MAC-address ending in `D9` clear for Virtual Machine `macvtap` bridging.

### Usage
1. Edit the `ifname` in the script to match your hardware.
2. Run `chmod +x set_static_ip.sh`
3. Execute `./set_static_ip.sh`

* **Note:**
 * If you just want assign a static IP to any machine/PC at OS-side, comment out [with an hash (`#`) on front of the line-s] the part-s of the script you don't need.

**Merit to:** [Gemini AI](https://deepmind.google/technologies/gemini/) (Collaboration for Network Stability)
