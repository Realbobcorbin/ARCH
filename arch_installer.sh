#!/bin/bash

# Arch Linux installer for full KDE setup
# Run from a live Arch USB

set -e

# Wipe and partition the disk (UEFI assumed)
disk="/dev/sda"

echo "Wiping and partitioning $disk..."
sgdisk -Z $disk
sgdisk -n1:0:+512M -t1:ef00 $disk
sgdisk -n2:0:0 -t2:8300 $disk

# Format and mount
echo "Formatting..."
mkfs.fat -F32 ${disk}1
mkfs.ext4 ${disk}2

mount ${disk}2 /mnt
mkdir /mnt/boot
mount ${disk}1 /mnt/boot

# Install base system
echo "Installing base system..."
pacstrap /mnt base linux linux-firmware grub efibootmgr networkmanager sudo vim plasma-meta kde-applications sddm xorg

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Copy post-install script
curl -o /mnt/post_install.sh https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/arch-kde-install/main/post_install.sh
chmod +x /mnt/post_install.sh

# Chroot and finish setup
arch-chroot /mnt ./post_install.sh
