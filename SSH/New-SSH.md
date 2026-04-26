# New-SSH.md
## Establishing the 'status quo'
```bash
# 1. Inspect existing environment
ls -l ~/.ssh

# 2. Backup old keys (ISO 9001 Requirement)
# Path: /run/media/tony/ARCO-ZFS-001/Network/SSH/Old-SSH/
# The script will ask: "Old SSH keys found. Do you want to back them up before generating new ones? (y/n)"
# If 'y', then: "Please enter backup path:" 

mkdir -p /run/media/tony/ARCO-ZFS-001/Network/SSH/Old-SSH/$(date +%Y%m%d_%H%M%S)
cp -p ~/.ssh/id_* /run/media/tony/ARCO-ZFS-001/Network/SSH/Old-SSH/$(date +%Y%m%d_%H%M%S)/



```bash
# ISO 9001 Reset - Performed on 2026-04-25
# 1. Full Backup of legacy keys and configs to:
# /run/media/tony/ARCO-ZFS-001/Network/SSH/Old-SSH/20260425/

# 2. New Master Key Generation (Ed25519)
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519 -C "Manager-PC-2026"

# 3. New Config Strategy
# We will manually add hosts as we deploy (Pi-hole, OPNsense, CRS326)
touch ~/.ssh/config
chmod 600 ~/.ssh/config

# 4. First Target Deployment (Pi-hole)
ssh-copy-id -i ~/.ssh/id_ed25519.pub admin_pi@192.168.1.10
```


# New-SSH.md

### 1. Pre-Setup: Backup & Cleanup
```bash
# Define Archive Path
BACKUP_DIR="/run/media/tony/ARCO-ZFS-001/Network/SSH/Old-SSH/$(date +%Y%m%d)"

# Backup legacy data
mkdir -p "$BACKUP_DIR"
mv ~/.ssh/* "$BACKUP_DIR/" 2>/dev/null

# Reset known_hosts (Clear old fingerprints)
ssh-keygen -R 192.168.1.10
```

### 2. Master Key Generation
```bash
# -t: Type, -N: Passphrase (empty), -f: Path, -C: Label
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519 -C "Manager-PC-2026"

# Secure config file permissions
touch ~/.ssh/config
chmod 600 ~/.ssh/config ~/.ssh/id_ed25519
```

### 3. Key Deployment (Initial Handshake)
```bash
# Syntax: ssh-copy-id -i [IdentityFile.pub] [RemoteUser]@[RemoteIP]
ssh-copy-id -i ~/.ssh/id_ed25519.pub admin_pi@192.168.1.10
```

### 4. Client Configuration (`~/.ssh/config`)
```bash
# 1. Exit the current remote session
exit

# 2. Run this on the Manager-PC to save the quick-access shortcut:
cat <<EOF >> ~/.ssh/config
Host pi-hole
    HostName 192.168.1.10
    User admin_pi
    IdentityFile ~/.ssh/id_ed25519
EOF

# 3. Final ISO 9001 Test (Passwordless login via alias)
ssh pi-hole

# 4. Verification/ terminal output
ssh pi-hole               
Linux pi-hole 6.12.75+rpt-rpi-2712 #1 SMP PREEMPT Debian 1:6.12.75-1+rpt1 (2026-03-11) aarch64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Sat Apr 25 11:26:13 2026 from 192.168.1.20
admin_pi@pi-hole:~ $ >

# SSH Connection Verified
# Date: 2026-04-25 18:55
# Status: SUCCESS

# Access Command:
ssh pi-hole

# Verification:
# - Logged in as: admin_pi
# - Remote Host: 192.168.1.10
# - Authentication: Ed25519 Key (Passwordless)

```
