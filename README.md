# 🚀 Arch + KDE Install Script

This script installs Arch Linux with the KDE Plasma desktop, using EXT4 and simple defaults.

---

## 📦 What It Does

- Wipes your disk (`/dev/sda`) ⚠️
- Sets up EFI boot
- Installs Arch Linux + KDE
- Enables SDDM (graphical login)
- Creates a user named `arch` with password `password`

---

## 🛠️ How to Use (From Arch Live ISO)

Boot into the Arch ISO and run:

```bash
curl -O https://raw.githubusercontent.com/Realbobcorbin/ARCH/main/arch_installer.sh
chmod +x arch_installer.sh
./arch_installer.sh
