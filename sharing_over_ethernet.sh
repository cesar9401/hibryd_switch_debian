#!/bin/bash
ETHERNET="enp1s0"
WIFI="wlp2s0"
IP="10.10.10.1"
SUBNET="10.10.10.0/24"

# enable ip forwarding
sudo sysctl -w net.ipv4.ip_forward=1

# assign a static IP to the ethernet interface
sudo ifconfig $ETHERNET $IP netmask 255.255.255.0 up

# enable masquerading on the interface which is connected to the internet
sudo iptables -t nat -A POSTROUTING -o $WIFI -j MASQUERADE

# add iptable rules to ACCEPT and FORWARD traffic from the subnet
sudo iptables -I FORWARD -o $WIFI -s $SUBNET -j ACCEPT
sleep 2

sudo iptables -I INPUT -s $SUBNET -j ACCEPT
sleep 2
