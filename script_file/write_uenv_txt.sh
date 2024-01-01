#!/bin/bash

# Specify the file name
file_name="uEnv.txt"

# Specify the content with an extra space at the end
content=$(cat <<EOL
console=ttyO0,115200n8
ipaddr=192.168.7.2
serverip=192.168.7.1
loadaddr=0x82000000
fdtaddr=0x88000000
loadfromsd=load mmc 0:2 \${loadaddr} /boot/uImage;load mmc 0:2 \${fdtaddr} /boot/am335x-boneblack.dtb
linuxbootargs=setenv bootargs console=\${console} root=/dev/mmcblk0p2 rw 
uenvcmd=setenv autoload no; run loadfromsd; run linuxbootargs; bootm \${loadaddr} - \${fdtaddr}

EOL
)

# Write to the file
echo -e "$content" > "$file_name"

echo "File '$file_name' generated successfully."

echo -e "\033[0;31m-----------------WARNING---------------------------------------------------"
echo -e "Add an extra line in 'uEnv.txt' file and save manually you can find in BOOT directory"
echo -e "-------------------------------------------------------------------------------------"
echo -e "\033[0m"
