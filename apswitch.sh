#!/bin/bash
ETHER_INTERFACE="enp1s0"
OLD_INTERFACE="wlp2s0"
INTERFACE="hotspot"
IP="10.10.20.1"

function turn_off_hostapd_udhcpd() {
    # killing hostapd
    # ps -e | grep hostapd
    if [ "$(ps -e | grep hostapd)" != "" ]
    then
        sudo pkill -ef hostapd
        sleep 1
    fi

    # killing udhcpd
    # ps -e | grep udhcpd
    if [ "$(ps -e | grep udhcpd)" != "" ]
    then
        sudo pkill -ef udhcpd
        sleep 1
    fi
}

# connecting ETHER_INTERFACE
# sudo nmcli device connect $ETHER_INTERFACE

# killing hostapd and udhcpd
turn_off_hostapd_udhcpd

# message
echo "creating new interface $INTERFACE with ip: $IP"

# turn off OLD_INTERFACE
sudo ifconfig $OLD_INTERFACE down

# check if INTERFACE exists
echo "checking for $INTERFACE interface..."
# out=$(ifconfig $INTERFACE)
# if [ $? -eq 0 ]
if [ "$(ifconfig | grep $INTERFACE)" != "" ]
then
    sudo ifconfig $INTERFACE down
    sleep 1
    # sudo iw dev $INTERFACE del
    # echo "Interface $INTERFACE has been removed"
    # sleep 1
else
    # setting up a virtual wireless interface of our existing interface wlp2s0 
    sudo iw phy phy0 interface add $INTERFACE type __ap
    sleep 1
fi

# setting up a virtual wireless interface of our existing interface wlp2s0 
# sudo iw phy phy0 interface add $INTERFACE type __ap

# set up the IP for our new interface
# sudo ifconfig $INTERFACE $IP netmask 255.255.255.0 up
sudo ifconfig $INTERFACE $IP up
sleep 1

# configuration for udhcpd
echo "creating /etc/udhcpd.conf"
sudo cp udhcpd.conf /etc/

# enable Network Address Translation NAT
sudo iptables --flush
sudo iptables --table nat --flush
sudo iptables --delete-chain
sudo iptables --table nat --delete-chain
sudo iptables --table nat --flush
# enable Network Address Translation NAT

sudo iptables --table nat --append POSTROUTING --out-interface $ETHER_INTERFACE -j MASQUERADE
sleep 2

sudo iptables --append FORWARD --in-interface $INTERFACE -j ACCEPT
sleep 2 

# giving access to internet to clients
# echo "1" > /proc/sys/net/ipv4/ip_forward
sudo sysctl -w net.ipv4.ip_forward=1
sleep 1
# sudo cp -i ip_forward /proc/sys/net/ipv4/

echo "Done, now we have the internet on the client device :D"
sleep 1

# run INTERFACE on background
sudo hostapd hostapd.conf &
sleep 2
sudo systemctl restart udhcpd.service

# run udchpd
sudo udhcpd -f

# disable NAT
# sudo iptables -D POSTROUTING -t nat -o $ETHER_INTERFACE -j MASQUERADE
sudo iptables --flush

# disable routing
sudo sysctl -w net.ipv4.ip_forward=0

# turn off hostapd and udhcpd
turn_off_hostapd_udhcpd
