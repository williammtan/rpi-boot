#!/bin/bash
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $1}')
TIME=$(date)
MESSAGE="Your Raspberry Pi ($HOSTNAME) just booted up.

Time: $TIME
Local IP: $IP"

echo "$MESSAGE" | mail -s "Raspberry Pi Boot: $HOSTNAME" your_email@gmail.com

