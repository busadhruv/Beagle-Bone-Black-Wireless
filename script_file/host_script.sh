#!/bin/bash
#user need to change below "wlp2s0" according to that 
sudo iptables --table nat --append POSTROUTING --out-interface wlp2s0 -j MASQUERADE

#user need to change below "eth0" according to that
sudo iptables --append FORWARD --in-interface eth0 -j ACCEPT
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

#sudo chmod +x host_script.sh (if not executable then give permission using chmod)
#in bbb route add default gw 192.168.7.1 eth0
#anf vi /etc/resolv.conf write nameserver 8.8.8.8 nameserver 8.8.4.4

echo "SUCCESSFULLY DONE.."
