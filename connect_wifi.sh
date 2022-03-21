#!/bin/bash

# if no $1 and $2
if [ -z $1 ] && [ -z $2 ]
then
    echo "Sin credenciales"
    return 1
fi

# turn on wlp2s0
sudo ifconfig wlp2s0 up

# connect to wifi
sudo nmcli d wifi connect $1 password $2
