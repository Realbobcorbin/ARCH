#!/bin/bash

# Arch Linux installer for full KDE setup
# Run from a live Arch USB

set -e

# Set your target disk
disk="/dev/sda"

# 🚨 Confirm before wiping the disk
read -p "⚠️ This will ERASE EVERYTHING on $disk. Are you sure? (y/N): " confirm
[[ $confirm != y* ]] && echo "Aborted." && exit 1

# 🧠 Make sure we're running in the live ISO environment
if ! grep -qs 'Arch Linux' /etc/os-release; then
  echo "⛔ Please run this from the Arch live ISO environment."
  exit 1
fi

echo "Wiping and partitioning $disk..."
sgdisk -Z $disk
sgdisk -n1:0:+512M -t1:ef00 $disk
sgdisk -n2:0:0 -t2:8300 $disk

echo "Formatting partitions..."
mkfs.fat -F32 ${disk}1
mkfs.ext4 ${disk}2

echo "Mounting partitions..."
mount ${disk}2 /mnt
mkdir /mnt/boot
mount ${disk}1 /mnt/boot

echo "Installing base system..."
pacstrap /mnt base linux linux-firmware grub efibootmgr networkmanager sudo vim plasma-meta kde-applications sddm xorg

echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

echo "Fetching post-install script..."
curl -o /mnt/post_install.sh https://raw.githubusercontent.com/Realbobcorbin/ARCH/main/post_install.sh
chmod +x /mnt/post_install.sh

echo "Entering chroot to finish setup..."
arch-chroot /mnt ./post_install.sh

echo "🎉 Installation complete! You can now reboot into KDE!"
