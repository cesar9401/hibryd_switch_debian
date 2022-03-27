#!/bin/bash

# agregar binarios al PATH
# de preferencia agregar el export al archivo /etc/profile y luego reiniciar
# export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin
echo $PATH

# sleep 2
# update and upgrade
sudo apt-get update
sleep 1
sudo apt-get upgrade
sleep 1

# install net-tools
sudo apt-get install net-tools

# sleep 2

# install hostapd
sudo apt-get install hostapd

# to configure hostapd you could
# edit /etc/default/hostapd
# uncommented DAEMON_CONF="/etc/hostapd/hostapd.conf"
# or use another configuration file for hostapd

# sleep 2

# install rfkill
sudo apt-get install rfkill

# sleep 2

# install udhcpd
# sudo apt-get install udhcpd

# install dnsmasq
sudo apt-get install dnsmasq

# install NetworkManager - nmcli
sudo apt-get install network-manager

sleep 1
sudo systemctl start NetworkManager.service
sleep 1
sudo systemctl enable NetworkManager.service

# sleep 2
echo "Done!"
