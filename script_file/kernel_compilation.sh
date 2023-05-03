#!/bin/bash

# Remove all the temporary files, object files, images generated during the previous build,
# including the .config file if created previously
echo "Remove all the temporary files, object files, images generated during the previous build"
make ARCH=arm distclean

# Check if the default configuration file exists
if [ ! -f arch/arm/configs/bb.org_defconfig ]; then
  echo "Default configuration file not found."
  echo "Please enter the name of the configuration file to use which you can find at this location /<linux_source>/arch/arm/configs/ : "
  read CONFIG_FILE
  make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- $CONFIG_FILE
else
  # Create a .config file by using default config file given by the vendor
  make ARCH=arm bb.org_defconfig
fi

# # Run menuconfig to customize kernel settings (optional)
echo "Do you want to customize kernel settings by running menuconfig? (y/n)"
read choice

if [ $choice == "y" ]
then
  make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
fi

# Kernel source code compilation. This stage creates a kernel image "uImage" also all the device tree source files will be compiled, and dtbs will be generated
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- uImage dtbs LOADADDR=0x80008000 -j4

# Build and generate in-tree loadable(M) kernel modules(.ko)
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules -j4

# Install all the generated .ko files in the default path of the computer (/lib/modules/<kernel_ver>)
sudo make ARCH=arm modules_install

