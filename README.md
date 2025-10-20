# rpi-boot
Simple setup to get a raspberry pi to send you an email during bootup.

## Setup msmtp
Install msmtp
```bash
sudo apt update
sudo apt install -y msmtp msmtp-mta mailutils
```
If you're using gmail, it's best to create a [MyApp Password](https://myaccount.google.com/apppasswords).
Edit the config file `/etc/msmtprc`:
```bash
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        /var/log/msmtp.log

account        gmail
host           smtp.gmail.com
port           587
from           your_email@gmail.com
user           your_email@gmail.com
password       your_app_password
account default : gmail
```
Test your msmtp
```bash
echo -e "Subject: msmtp test\n\nHello" | msmtp -a default your_email@gmail.com
```

## Setup script
First, save this script in some arbritrary location like `/usr/local/bin/send-boot-email.sh`:
```bash
#!/bin/bash
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $1}')
TIME=$(date)
MESSAGE="Your Raspberry Pi ($HOSTNAME) just booted up.

Time: $TIME
Local IP: $IP"

echo "$MESSAGE" | mail -s "Raspberry Pi Boot: $HOSTNAME" your_email@gmail.com
```
Make it executable
```bash
sudo chmod +x /usr/local/bin/send-boot-email.sh
```
Test the script
```bash
/usr/local/bin/send-boot-email.sh
```
## Setup processd
Edit the file `/etc/systemd/system/send-boot-email.service`:
```
[Unit]
Description=Send email on boot
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/send-boot-email.sh

[Install]
WantedBy=multi-user.target
```
Enable and start
```bash
sudo systemctl enable send-boot-email.service
```
Now reboot (`sudo reboot`) and check your inbox.

Done!
