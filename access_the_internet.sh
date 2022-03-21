#!/bin/bash

echo "Starting...\\n"

echo "1" > /proc/sys/net/ipv4/ip_forward

# sudo cp -i ip_forward /proc/sys/net/ipv4/

iptables --table nat --append POSTROUTING --out-interface enp1s0 -j MASQUERADE

iptables --append FORWARD --in-interface hotspot -j ACCEPT

echo "now we have the internet on the client device :D"
