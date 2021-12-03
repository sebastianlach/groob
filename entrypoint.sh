#!/bin/sh -e

FILENAME=groob.img
ESPIMAGE=esp.img

# generate grub standalone
echo 'configfile ${cmdpath}/grub.cfg' > /tmp/grub.cfg
grub-mkstandalone \
    --directory=/usr/lib/grub/x86_64-efi/ \
    --format=x86_64-efi \
    --modules="part_gpt part_msdos" \
    --locales="en@quot" \
    --themes="" \
    --output "grubx64.efi" \
    "boot/grub/grub.cfg=/tmp/grub.cfg"

# generate first part
rm -f ${FILENAME}
fallocate -l 1M ${FILENAME}

# generate ESP partition
fallocate -l 127M ${ESPIMAGE}
mkfs.vfat -F 32 -n BOOT ${ESPIMAGE}
mmd -i ${ESPIMAGE} ::EFI
mmd -i ${ESPIMAGE} ::EFI/grub
mcopy -i ${ESPIMAGE} grubx64.efi ::EFI/grub/

# merge partitions
dd if=${ESPIMAGE} of=${FILENAME} bs=1M oflag=append conv=notrunc
rm -f ${ESPIMAGE}

# add partition table
parted -s ${FILENAME} mklabel msdos
parted -s -a none ${FILENAME} mkpart primary fat32 1MiB 100%
parted -s ${FILENAME} set 1 boot on
parted -s ${FILENAME} set 1 esp on
