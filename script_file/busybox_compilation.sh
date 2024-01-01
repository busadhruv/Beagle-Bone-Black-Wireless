#!/bin/bash

# BusyBox Compilation Script

echo "$(pwd)"

ROOTFS_DIR="ROOTFS"

# Check if ROOTFS directory exists
if [ -d "$ROOTFS_DIR" ]; then
    read -p "ROOTFS directory already exists. Do you want to remove it? (y/n)" choice_remove
    if [ "$choice_remove" == "y" ]; then
        echo "Removing existing ROOTFS directory..."
        rm -r "$ROOTFS_DIR"
    else
        echo "Compilation aborted. Existing ROOTFS directory not removed."
        exit 1
    fi
fi

mkdir "$ROOTFS_DIR"
cd busybox/

# STEP 1: Remove all previously compiled object files

read -p "Remove all previously compiled object files? (y/n)" choice_clean
if [ "$choice_clean" == "y" ]; then
    echo "Remove all previously compiled object files"
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- distclean
fi

# STEP 2: Apply board default configuration for BusyBox

read -p "Do you want to apply board default configuration for BusyBox? (y/n)" choice_defconfig
if [ "$choice_defconfig" == "y" ]; then
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- defconfig
fi

# STEP 3: Run menuconfig to customize kernel settings (optional)

read -p "Do you want to customize kernel settings by running menuconfig? (y/n)" choice_menuconfig
if [ "$choice_menuconfig" == "y" ]; then
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
fi

# STEP 4: Compile BusyBox

read -p "Do you want to generate RFS? (y/n)" choice_generate_rfs
if [ "$choice_generate_rfs" == "y" ]; then
    cd ../
    cd "$ROOTFS_DIR/"
    current_directory=$(pwd)
    cd ../busybox/ || exit 1
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- CONFIG_PREFIX="$current_directory" install
    cd ../
    echo "------For extra files add to ROOTFS------"
    source busybox_after_compile.sh
    echo "------DONE ROOTFS GENERATED--------------"
else
    echo "ROOTFS NOT GENERATED............."
    exit 1
fi

