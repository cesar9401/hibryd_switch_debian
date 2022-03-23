#!/bin/bash
ETHER_INTERFACE="enp1s0"
OLD_INTERFACE="wlp2s0"
INTERFACE="hotspot"
IP="192.168.28.1"

# message
echo "creating new interface $INTERFACE with ip: $IP"

# turn off OLD_INTERFACE
sudo ifconfig $OLD_INTERFACE down

# check if INTERFACE exists
echo "checking for $INTERFACE interface..."
out=$(ifconfig $INTERFACE 2>&1)
if [ $? -eq 0 ]
then
    sudo iw dev $INTERFACE del
    echo "Interface $INTERFACE has been removed"
fi

sleep 1
# setting up a virtual wireless interface of our existing interface wlp2s0 
sudo iw phy phy0 interface add $INTERFACE type __ap

sleep 1
# set up the IP for our new interface
sudo ifconfig $INTERFACE $IP up

sleep 1
# run INTERFACE on background
sudo hostapd hostapd.conf &

sleep 2
# configuration for udhcpd
echo "creating /etc/udhcpd.conf"
sudo cp udhcpd.conf /etc/udhcpd.conf
sleep 2

# run udchpd
sudo udhcpd &
echo "Done!"

# giving access to internet to clients
echo "1" > /proc/sys/net/ipv4/ip_forward
sleep 1
# sudo cp -i ip_forward /proc/sys/net/ipv4/

sudo iptables --table nat --append POSTROUTING --out-interface $ETHER_INTERFACE -j MASQUERADE
sleep 2

sudo iptables --append FORWARD --in-interface $INTERFACE -j ACCEPT
sleep 2

echo "now we have the internet on the client device :D"
