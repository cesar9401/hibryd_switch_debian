#!/bin/bash

echo "Looking for wifi connections"
echo ""

# wlp2so
sudo ifconfig wlp2s0 up

# lookig for connections
sudo iwlist wlp2s0 scan | grep ESSID
