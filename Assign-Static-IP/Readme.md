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
 * Here a script is inevitable because as soon as the network manager no longer has a working internet connection, he would try constantly to reconfigure & start the local NICs ports.
 * Therefore, before you make the script executable & start it, use the `ip a` command to collect all the necessary information about your machine & adjust the script accordingly. Assure you choose the right `ifname` through the command `nmcli device status`, find the output of my machine below. Explanations are also in the form of comments within the script itself.
 * If necessary, comment with a hash (`#`) at the beginning of each line that you should not need.

 ```bash
mcli device status
DEVICE        TYPE      STATE                   CONNECTION     
enp65s0f0np0  ethernet  connected               Admin-Port-1   
enp65s0f1np1  ethernet  connected               VM-Bridge-Port 
lo            loopback  connected (externally)  lo             
enp65s0f2np2  ethernet  unavailable             --             
enp65s0f3np3  ethernet  unavailable             --             
enp8s0        ethernet  unavailable             --   
```

**Merit to:** [Gemini AI](https://deepmind.google/technologies/gemini/) (Collaboration for Network Stability)

