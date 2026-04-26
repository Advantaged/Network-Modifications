# New-SSH.md

## Generalization & Compatibility Note
**Standardized procedure for establishing, hardening, and maintaining SSH Key-Based Authentication.**
* **Note on Compatibility:** This guide uses **CachyOS** (Arch-based) for the Manager-Machine and **Debian/Raspberry Pi OS** for clients as primary examples. However, the logic and verification steps apply to **all Linux distributions** (Fedora, Ubuntu, etc.) by adjusting the package manager commands (e.g., using `apt` or `dnf` instead of `pacman`).

---

## 1. Scope & Definitions
The goal is to move from insecure password authentication to **Ed25519 Key-Based Authentication** on a non-standard port.

* **Manager-Machine (Host):** Your central PC (CachyOS Admin-Workstation). Holds the **Private Key**.
* **Client (Target-Machine):** Any device being managed (Pi-hole, SFF-PC, Switch). Holds the **Public Key**.
* **Management-User:** Your local user (e.g., `tony`).
* **Target-User:** The user on the Client (e.g., `admin_pi`). **Must have sudo rights.**

---

## 2. Critical Pre-Check: Legacy Systems
**WARNING:** If a Client (e.g., `lena-24`) already has `PasswordAuthentication no` set in its `/etc/ssh/sshd_config` and you have deleted the corresponding private key on your Manager-Machine, **Remote Access is LOST.**

**Recovery Options:**
1.  **Physical Access:** Plug in a keyboard/monitor to the Client.
2.  **Temporary Re-enabling:** Edit `/etc/ssh/sshd_config` on the client, set `PasswordAuthentication yes`, and `sudo systemctl restart ssh`.
3.  **Key Injection:** Manually append your new `id_ed25519.pub` content to `~/.ssh/authorized_keys` on the Client.

---

## 3. The ISO 9001 Action Plan

### Step A: Clean Slate (Manager-Machine)
1. Backup old keys to ZFS: `/run/media/tony/ARCO-ZFS-001/Network/SSH/Old-SSH/`
2. Generate new Master Key: `ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519 -C "Manager-PC-2026"`

### Step B: The "Two-Tab" Port Transition (Pi-hole Example)
1. **Tab 1:** Stay logged in via current SSH.
2. **Edit Config:** `sudo nano /etc/ssh/sshd_config`
   * Set `Port 52222` (or your chosen high port).
   * Ensure `PubkeyAuthentication yes`.
   * Keep `PasswordAuthentication yes` (Temporary!).
3. **Restart Service:** `sudo systemctl restart ssh`.
4. **Tab 2:** Attempt connection: `ssh -p 52222 admin_pi@192.168.1.10`.
5. **Finalize:** If Tab 2 works, disable `PasswordAuthentication` in Tab 1, restart again, and test once more.

### Step C: The "Teergrube" (Tar-pit)
Once the real SSH moves to Port 52222, Port 22 is open.
* **Action:** Install `endlessh` on the Client.
* **Benefit:** Bots hitting Port 22 are trapped in a slow-motion connection, wasting their resources while your real port remains hidden.

---

## 4. Automation
The following script `ssh-manager.sh` automates the backup, key generation, and client deployment.

[See separate script file: ssh-manager.sh]
