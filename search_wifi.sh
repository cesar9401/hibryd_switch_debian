#!/bin/bash

echo "Looking for wifi connections"

# wlp2so
sudo ifconfig wlp2s0 up

# lookig for connections
sudo iwlist wlp2s0 scan | grep ESSID
