#!/bin/bash

set -e

# Set timezone and locale
ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set hostname
echo "arch" > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1 localhost
::1       localhost
127.0.1.1 arch.localdomain arch
EOF

# Create user
useradd -m -G wheel arch
echo arch:password | chpasswd
echo "root:password" | chpasswd

# Enable sudo for wheel group
sed -i 's/^# %wheel/%wheel/' /etc/sudoers

# Enable services
systemctl enable NetworkManager
systemctl enable sddm

# Install GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "Install complete. Reboot now!"
