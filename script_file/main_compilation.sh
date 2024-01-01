echo "----------Compilation of every source code-----------"

read -p "you want to compile linux kernel for uimage/dtb (y/n)?" choice
if [ $choice == "y" ]
then
echo "Compiling kernel......"
source kernel_compilation.sh
fi

read -p "you want to compile u-boot for u-boot.img/MLO (y/n)?" choice
if [ $choice == "y" ]
then
echo "Compiling u-boot......"
source u-boot_compilation.sh
fi

read -p "you want to compile busybox for ROOTFS (y/n)?" choice
if [ $choice == "y" ]
then
echo "Compiling busybox......"
source busybox_compilation.sh
fi
echo "----------Compilation Done-----------"

echo "----------Copying file to BOOT Directory-----------"
source copy_to_dir.sh
echo "-----------Ready to flash on BBBW-------------------------"
