#!/bin/bash
echo "SETTING DNS CONFIGURATION DONE.."
echo "ADD DEFAULT GATEWAY SUCCESSFULLY..."
sudo echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
sudo echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf > /dev/null
#user need to change below ip "192.168.7.1" according to that 
sudo route add default gw 192.168.7.1 usb0
echo "SUCCESSFULLY DONE.."

