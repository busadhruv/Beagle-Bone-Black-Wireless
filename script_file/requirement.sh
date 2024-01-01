#!/bin/bash

# ...

sudo apt-get update -y
chmod +x main_compilation.ch kernel_compilation.sh u-boot_compilation.sh busybox_compilation.sh busybox_after_compile.sh copy_to_dir.sh write_uenv_txt.sh

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "Installing curl..."
    sudo apt-get install curl -y
fi

# Check if GParted is installed
if ! dpkg -l | grep -q gparted; then
    echo "--------------------------------------------------------------"
    echo "        Download Gparted application for SD card format       "
    echo "--------------------------------------------------------------"
    sudo apt-get install gparted -y
else
    echo "GParted is already installed. No need to download."
fi

# Check GCC version
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

if command -v arm-linux-gnueabihf-gcc &> /dev/null; then
    echo "--------------------------------------------------------------"
    echo "                   GCC Linaro is already installed            "
    echo "--------------------------------------------------------------"
else
    echo "--------------------------------------------------------------------------"
    echo "                       Installing GCC linaro                              "
    echo "--------------------------------------------------------------------------"

    # Specify the download link
    download_link="https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/arm-linux-gnueabihf/gcc-linaro-5.4.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz"

    # ... rest of the installation process

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
fi

# Check if U-Boot directory exists
if [ -d "U_BOOT" ]; then
    echo "--------------------------------------------------------------"
    echo "                  U-BOOT is already downloaded                "
    echo "--------------------------------------------------------------"
else
    echo "--------------------------------------------------------------"
    echo "                  U-BOOT Source code download                 "
    echo "--------------------------------------------------------------"

    # Create the U_BOOT directory if it doesn't exist
    mkdir -p U_BOOT

    # Navigate to the U_BOOT directory
    cd U_BOOT || exit 1

    # U-BOOT Source code download
    git clone git://git.denx.de/u-boot.git .

    cd ..
fi

# Check if the directory and ZIP file exist
if [ -d "LINUX_SOURCE_CODE" ]; then
    echo "--------------------------------------------------------------"
    echo "            LINUX Source is already downloaded                "
    echo "--------------------------------------------------------------"
elif [ -e "linux-5.4.106-ti-r42.zip" ]; then
    echo "Downloaded ZIP file is available. Extracting files... Wait.........."
    
    # Extract the downloaded ZIP file directly into LINUX_SOURCE_CODE
    unzip -q "linux-5.4.106-ti-r42.zip"
    sudo mv linux-5.4.106-ti-r42 LINUX_SOURCE_CODE

    # Check if the extraction was successful
    if [ $? -eq 0 ]; then
        echo "Extraction successful."
    else
        echo "Extraction failed. Please check the ZIP file or try again later."
    fi
else
    echo "--------------------------------------------------------------"
    echo "                  LINUX Source code download                  "
    echo "--------------------------------------------------------------"

    # LINUX Source code download
    zip_url="https://github.com/beagleboard/linux/archive/v5.4.106-ti-r42.zip"

    # Download the ZIP file using curl
    curl -LJO "$zip_url"

    linux_zip_path=$(pwd)
    mkdir LINUX_SOURCE_CODE

    cd LINUX_SOURCE_CODE/ || exit 1

    # Check if the download was successful
    if [ $? -eq 0 ]; then
        echo "Download successful. Extracting files..."

        # Extract the downloaded ZIP file
        unzip -q "$linux_zip_path/linux-5.4.106-ti-r42.zip" -d "$(pwd)"

        # Check if the extraction was successful
        if [ $? -eq 0 ]; then
            echo "Extraction successful."
        else
            echo "Extraction failed. Please check the ZIP file or try again later."
        fi
        cd ..
    fi
fi


# Check if busybox directory exists
if [ -d "busybox" ]; then
    echo "----------------------------------------------------------------"
    echo "            BUSYBOX Source is already downloaded                "
    echo "----------------------------------------------------------------"
else
    echo "--------------------------------------------------------------"
    echo "       Do you want to download BusyBox source code? (y/n)     "
    read -r download_busybox

    if [ "$download_busybox" = "y" ]; then
        # Download and extract BusyBox directly into busybox directory
        busybox_link="https://busybox.net/downloads/busybox-1.36.0.tar.bz2"
        mkdir -p busybox
        wget "$busybox_link" -O - | tar xj -C busybox/ --strip-components=1
    fi
    cd ../../
fi

echo "---------------------------------------------------------------------------------------------------------"
echo "                You need to Compile Both Source code for that run ./main_compilation.sh                  "            
echo "---------------------------------------------------------------------------------------------------------"

