#!/bin/bash

# U-boot Compilation Script

# STEP 1: Remove all previously compiled object files
read -p " Remove all previously compiled object files? (y/n)" choice
if [ $choice == "y" ]
then
echo "Remove all previously compiled object files"
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- distclean
fi

# STEP 2: Apply board default configuration for U-Boot
read -p "Do you want to apply board default configuration for U-Boot? (y/n)" choice
if [ $choice == "y" ]
then
  read -p "Enter board config file name which you can find /<u-boot source>/connfigs/: " board_config
  make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- $board_config
fi

# STEP 3: Run menuconfig to customize kernel settings (optional)
read -p "Do you want to customize kernel settings by running menuconfig? (y/n)" choice
if [ $choice == "y" ]
then
  make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
fi

# STEP 4: Compile U-Boot
read -p "Do you want to compile U-Boot? (y/n)" choice
if [ $choice == "y" ]
then
  echo "Enter 4 or 8"
  read CORES
  make CROSS_COMPILE=arm-linux-gnueabihf- -j${CORES}
  
  cd ~
  if [ ! -d "$HOME/U-BOOT_FILES" ]; then
    mkdir "$HOME/U-BOOT_FILES"
  fi
  cd -
  sudo cp -a u-boot.img MLO ~/U-BOOT_FILES
fi

