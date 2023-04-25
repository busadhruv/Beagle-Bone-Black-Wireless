#!/bin/bash
echo "Connecting to Wi-Fi...."
echo "Wait for 30-60 second."

if [ $# -ne 2 ]; then
    echo "Usage: $0 <SSID> <password>"
    exit 1
fi

# Below command is used when any error occur for restarting the service
# Connect to Wi-Fi
#sudo rm /run/wpa_supplicant/wlan0
#sudo systemctl restart networking.service

# Set Wi-Fi SSID and password
SSID="$1"
PASSWORD="$2"

# Configure Wi-Fi connection
sudo tee /etc/network/interfaces >/dev/null <<EOF
auto wlan0
iface wlan0 inet dhcp
    wpa-ssid "$SSID"
    wpa-psk "$PASSWORD"
EOF

echo ""
echo "Checking Wi-Fi connection..."

# Restart networking service
sudo systemctl restart networking.service

# Wait for Wi-Fi connection to be established
#echo "Please wait while we connect to Wi-Fi..."
#for i in {1..10}; do
 #   echo -n "."
 #   sleep 1
#done

# Check Wi-Fi connection
iwconfig wlan0 | grep "ESSID:\"$SSID\"" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Wi-Fi connection successful!"
else
    echo "Failed to connect to Wi-Fi!"
fi
