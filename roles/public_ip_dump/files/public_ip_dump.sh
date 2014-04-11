#!/bin/bash

IP=`curl -s checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'`
echo $IP > /home/pi/about/ip.txt
