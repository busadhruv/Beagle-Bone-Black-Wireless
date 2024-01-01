echo "----------------------------------------------------------------------------------------------"
echo "    Copying a u-booy.img,uimage,am335x-boneblack-wireless.dtb,MLO file in BOOT directory      "
echo "----------------------------------------------------------------------------------------------"

#!/bin/bash
# Check if BOOT directory exists
if [ ! -d "BOOT" ]; then
    mkdir BOOT
    echo "BOOT directory created."
else
    echo "BOOT directory already exists."
fi
cd U_BOOT/
uboot_directory=$(pwd)


# U-Boot files
U_BOOT_SRC_DIR="$uboot_directory"  # Replace with the actual path
U_BOOT_IMG="u-boot.img"
MLO_FILE="MLO"

cd ../
cd LINUX_SOURCE_CODE/
kernel_directory=$(pwd)

# Linux kernel files
LINUX_SRC_DIR="$kernel_directory"  # Replace with the actual path
UIMAGE="arch/arm/boot/uImage"
DTB_FILE="arch/arm/boot/dts/am335x-boneblack-wireless.dtb"

cd ../

echo "writing uEnv.txt file"
source write_uenv_txt.sh

cd BOOT/
BOOT_DIR=$(pwd)
cd ../
UENV_DIR=$(pwd)
# Copy files to the BOOT directory
cp "$U_BOOT_SRC_DIR/$U_BOOT_IMG" "$BOOT_DIR/"
cp "$U_BOOT_SRC_DIR/$MLO_FILE" "$BOOT_DIR/"
cp "$LINUX_SRC_DIR/$UIMAGE" "$BOOT_DIR/"
cp "$LINUX_SRC_DIR/$DTB_FILE" "$BOOT_DIR/"
mv "$UENV_DIR/uEnv.txt" "$BOOT_DIR/"

echo "Files copied to the BOOT directory"

