#!/bin/bash

# Author: Gregory Johnson, gregjohnso@gmail.com
# Jul 31, 2016
# 
# Inspired by http://www.online-tech-tips.com/computer-tips/how-to-change-mac-address/
# and http://osxdaily.com/2007/01/18/airport-the-little-known-command-line-wireless-utility/
# and Boingo Hotspot and O'Hare International Airport


# get the input device 
DEVICE=$1

# get the mac address corresponding to the device
OLD_MAC="$(ifconfig $DEVICE | grep ether | cut -d ' ' -f 2)"

echo "old MAC address is ${OLD_MAC}"

echo "generating new MAC address"

NEW_MAC="$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g;s/.$//')"

echo "new MAC address is ${NEW_MAC}"

# this is a good
sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -z
sleep 1
sudo ifconfig $DEVICE ether $NEW_MAC

VERIFY_MAC="$(ifconfig $DEVICE | grep ether | cut -d ' ' -f 2)"

if [ "$NEW_MAC" = "$VERIFY_MAC" ]
then
	echo "MAC address successfully changed."
else
	echo "MAC address NOT successfully changed."
fi

# turn the 
sudo ifconfig $DEVICE up