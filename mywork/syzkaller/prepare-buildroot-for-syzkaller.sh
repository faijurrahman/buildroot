#!/bin/bash

#-----------------------------------------------------------------------
# Setup Source Code
#-----------------------------------------------------------------------
git clone https://github.com/buildroot/buildroot
cd buildroot

#git remote add origin https://github.com/buildroot/buildroot
#git branch --set-upstream-to=origin/master master

git branch -vv
git remote -vv

git remote add upstream https://gitlab.com/buildroot.org/buildroot.git
git remote add dev git@github.com:faijurrahman/buildroot.git

git branch -vv
git remote -vv


#-----------------------------------------------------------------------
# Configure buildroot for Syzkaller
#-----------------------------------------------------------------------
make distclean
make qemu_aarch64_virt_defconfig
make menuconfig

# Update config based on the following:
Target options
    Target Architecture - Aarch64 (little endian)
Toolchain type
    External toolchain - Linaro AArch64
System Configuration
[*] Enable root login with password
        ( ) Root password = set your password using this option
[*] Run a getty (login prompt) after boot  --->
    TTY port - ttyAMA0
Target packages
    [*]   Show packages that are also provided by busybox
    Networking applications
        [*] dhcpcd
        [*] iproute2
        [*] openssh
Filesystem images
    [*] ext2/3/4 root filesystem
        ext2/3/4 variant - ext3
        exact size in blocks - 6000000
    [*] tar the root filesystem


#-----------------------------------------------------------------------
# Build rootfs for Syzkaller
#-----------------------------------------------------------------------
make -j$(nproc)
