# 🚀 Why do we need UDEV and Static IPs? (The "Simple" Guide)

If you are building a Home-Lab with 10Gbps or 40Gbps speeds, "standard" settings are not enough. Here is why we use these specific tools:

### 1. What are UDEV Rules?
Think of **UDEV** as a "Welcome Committee" for your hardware. 
* **The Problem:** Normally, when Linux starts, it treats every Network Card like a standard 1Gbps card. It uses small "envelopes" (MTU 1500) and small "waiting rooms" (Queue Length 1000).
* **The Solution:** Our UDEV rule tells the system: "Hey! This is a high-speed Racing Car. Use huge boxes (MTU 9000) and a massive waiting room (Queue 10000) so the data doesn't crash."
* **Why "Autoneg Off"?** Sometimes, the Switch and the PC try to "negotiate" the speed like two people arguing. Disabling this forces them to stop talking and just start working at 10Gbps.

### 2. What is a Static IP?
Imagine you move into a new house (the Network), but every time you wake up, the mailman gives you a different House Number (IP Address). 
* **The Problem:** Your Server (TrueNAS) or your Switches (MikroTik) won't be able to find you if your "Number" keeps changing.
* **The Solution:** A Static IP is like a permanent Nameplate on your door. You will always be `192.168.1.2`, so the network always knows where to send the data.

### 3. What are Jumbo Frames (MTU 9000)?
* **Standard (1500):** Like moving 10,000 bricks using a small bicycle. It takes forever, and the rider (your CPU) gets very tired.
* **Jumbo (9000):** Like moving those same bricks using a large truck. One trip, much faster, and the CPU stays cool.

---

## 🛠 Useful Commands for Troubleshooting

If things feel "slow" or "strange," use these commands to check your work:

**Check if your "Truck" (MTU) and "Waiting Room" (Queue) are ready:**
```bash
ip link show [your-nic-name]
```

