#!/bin/bash

sudo apt-get update -y

# Check GCC version
echo "--------------------------------------------------------------"
echo "        Download Gparted application for SD card format       "
echo "--------------------------------------------------------------"
sudo apt-get install gparted -y

echo "Checking GCC version....."
gcc_version=$(gcc --version | awk 'NR==1{print $3}')
required_version="6.0.0"

if [[ "$(printf '%s\n' "$required_version" "$gcc_version" | sort -V | head -n1)" == "$required_version" ]]; then
  echo "GCC version is $gcc_version. No need to install a newer version."
else
  # Install GCC if the version is older than 6.0
  sudo apt-get install gcc-arm-linux-gnueabihf
  export CROSS_COMPILE=arm-linux-gnueabihf-
  echo "Installed GCC version: $(gcc --version)"
fi

echo "--------------------------------------------------------------------------"
echo "                       Installing GCC linaro                              "
echo "--------------------------------------------------------------------------"

# Specify the download link
download_link="https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/arm-linux-gnueabihf/gcc-linaro-5.4.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz"

cd ..

# Create the target directory if it doesn't exist
mkdir -p "downloads"

# Navigate to the target directory
cd downloads/ || exit 1

# Download the file
wget "$download_link"

# Verify if the download was successful
if [ $? -eq 0 ]; then
  echo "Download successful. The file is saved in: downloads/"
  echo "----------------------------------------------------"
  echo "  Now gcc linaro configured and set path in system  "
  echo "----------------------------------------------------"

  # Extract the downloaded file
  sudo tar xvf gcc-linaro-5.4.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz -C /opt/

  # Move the extracted directory to a desired location
  sudo mv /opt/gcc-linaro-5.4.1-2017.05-x86_64_arm-linux-gnueabihf/ /opt/gcc-arm-linux

  # Add the compiler's bin directory to the PATH
  export PATH=$PATH:/opt/gcc-arm-linux/bin
  echo "Compiler added to PATH."
else
  echo "Download failed. Please check the download link or try again later."
fi

echo "--------------------------------------------------------------"
echo "                  U-BOOT Source code download                 "
echo "--------------------------------------------------------------"

cd ..

# U-BOOT Source code download
git clone git://git.denx.de/u-boot.git u-boot/

echo "--------------------------------------------------------------"
echo "                  LINUX Source code download                  "
echo "--------------------------------------------------------------"

# LINUX Source code download
git clone https://github.com/beagleboard/linux.git


echo "--------------------------------------------------------------"
echo "             You need to Compile Both Source code             "
echo "--------------------------------------------------------------"

