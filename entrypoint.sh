#!/bin/sh -e

# generate first part
rm -f gboot.img
fallocate -l 1M gboot.img

# generate main part
fallocate -l 2047M boot.img
mkfs.vfat -F 32 -n BOOT boot.img
mmd -i boot.img ::EFI
mkdir /boot
mount boot.img /boot
grub-install --target=x86_64-efi --efi-directory=/boot --removable --bootloader-id gboot
touch /overlay
grub-mkconfig -o /boot/grub/grub.cfg
umount /boot

# merge parts
dd if=boot.img of=gboot.img bs=1M oflag=append conv=notrunc
rm -f boot.img

# add partition table
parted gboot.img mklabel msdos
parted -a none gboot.img mkpart primary fat32 1MiB 100%
parted gboot.img set 1 boot on
parted gboot.img set 1 esp on
