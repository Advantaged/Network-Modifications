# SSH-Master-Setup.md (ISO 9001 Standard)

## 1. Definitions
* **Manager (Admin):** Your main workstation (The "Remote Control").
* **Client (Target):** The remote PC/Pi/SFF you want to control (The "Device").
* **Static IP:** A fixed network address. **Crucial:** Assign this in your Router's "DHCP Reservation" settings before you begin.

---

## 2. Admin-PC: Initial Setup (The "Zero" State)
*Use this only once to prepare your main workstation.*

### 2.1. Basic Tools & Firewall
```bash
sudo pacman -S --needed openssh ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 52222/tcp comment 'SSH Port'
sudo ufw enable && sudo ufw status verbose
```

### 2.2. Credentials Generation
```bash
# Start fresh: delete old keys and generate a Master Key
rm -rf ~/.ssh/*
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519 -C "Manager-PC-2026"
```

---

## 3. Joining the SSH Circle (Adding a Machine)
*Follow these steps for every new Client you want to add.*

### 3.1. Physical Access Phase (At the Client's Monitor)

1. **Service Check:** 
   Check if SSH is already installed.
   ```bash
   systemctl list-unit-files | grep ssh
   ```

2. **Install & Configuration:**
   
   ```bash
   # Arch/CachyOS: sudo pacman -S --needed openssh
   # Debian/Pi: sudo apt install openssh-server -y
   
   sudo nano /etc/ssh/sshd_config
   ```
   **Edit these lines (remove '#' if present):**
   * `Port 52222`
   * `PubkeyAuthentication yes`
   * `PasswordAuthentication yes`
   * `PermitEmptyPasswords no`

3. **Install and/or Activate Firewall:**
   *Check if a firewall is installed*
   ```bash
   # Check Firewall status
   sudo ufw status || echo "UFW not installed/active"
   ```
   *If no Firewall is yet installed & you wish to have one:*
   ```bash
   # Arch/CachyOS: sudo pacman -S --needed ufw
   # Debian/Pi: sudo apt install ufw -y
   ```

4. **Open the Gate (Firewall):**
   *Apply these settings if a firewall (UFW) is installed:*
   ```bash
   sudo ufw allow 52222/tcp comment 'Allow SSH'
   sudo ufw reload
   sudo ufw status verbose # Counter-check!
   ```

5. **Activate SSH-Service:**
   ```bash
   # CachyOS: sshd.service | Debian/Pi: ssh.service
   sudo systemctl enable --now sshd.service
   sudo systemctl restart sshd.service
   sudo ss -tulpn | grep ssh # Verify it listens on 52222
   ```

6. **Data Collection:**
   * Run `whoami` (Note your Username: ________)
   * Run `ip a` (Note your IP Address: ________)

---

### 3.2. Handshake Phase (Back at your Admin-PC)

1. **Transfer the Key:**
   Replace `[user]` and `[ip]` with your noted data.
   ```bash
   ssh-copy-id -p 52222 -i ~/.ssh/id_ed25519.pub [user]@[ip]
   ```

2. **The Phonebook Setup:**
   Create/Edit the config: `nano ~/.ssh/config`
   ```text
   Host [shortcut-name]
       HostName [IP-Address]
       User [Username]
       Port 52222
       IdentityFile ~/.ssh/id_ed25519
   ```

3. **Verify Connection:**
   `ssh [shortcut-name]` -> You must be logged in without a password prompt.

---

### 3.3. Hardening Phase (Remote via SSH)

Now that you are connected via your shortcut, lock the door:
1. `sudo nano /etc/ssh/sshd_config`
2. Set `PasswordAuthentication no`
3. `sudo systemctl restart sshd.service` (or `ssh.service`)
4. **Check SSH-Service:** `systemctl status sshd.service`
5. **Check Key-Only Login:** 
   Exit the session with `exit`, then try connecting again:
   `ssh [shortcut-name]`
   *If it works without asking for a password, the Circle is complete.*
