#!/bin/sh

set -e

# Create the revert script for manually switching back to the previously
# active firmware.
mkdir -p $TARGET_DIR/usr/share/fwup
$HOST_DIR/usr/bin/fwup -c -f $NERVES_DEFCONFIG_DIR/fwup-revert.conf -o $TARGET_DIR/usr/share/fwup/revert.fw

# Copy the fwup includes to the images dir
cp -rf $NERVES_DEFCONFIG_DIR/fwup_include $BINARIES_DIR

# Remove the boot files from the rootfs
rm -rf $TARGET_DIR/boot/*

# Compress the initramfs files
# Linux 4.9 does seem to be capable of enumerating compressed concatenated archives
# The kernel fails to mount a viable rootfs. Therefore, reduce the archives to
# CPIO and concatenate.
$BINARIES_DIR/file-to-cpio.sh "$NERVES_DEFCONFIG_DIR/nerves_initramfs.conf" "$BINARIES_DIR/nerves_initramfs.conf.cpio"
$BINARIES_DIR/file-to-cpio.sh "$TARGET_DIR/usr/share/fwup/revert.fw" "$BINARIES_DIR/revert.fw.cpio"

gunzip -cd "$BINARIES_DIR/nerves_initramfs_aarch64.gz" >> "$BINARIES_DIR/nerves_initramfs_aarch64.cipo"
cat "$BINARIES_DIR/nerves_initramfs_aarch64.cipo" "$BINARIES_DIR/nerves_initramfs.conf.cpio" "$BINARIES_DIR/revert.fw.cpio" >> "$BINARIES_DIR/nerves_initramfs"
gzip -9 -n -f "$BINARIES_DIR/nerves_initramfs"

# Form an image U-Boot is capable of reading.
mkimage -A arm64 -O linux -T ramdisk -n 'Ramdisk Image' -d "$BINARIES_DIR/nerves_initramfs.gz" "$BINARIES_DIR/nerves_initramfs.uImage"
