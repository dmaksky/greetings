#!/usr/bin/env bash
app=greetings
# Update the OS and add a user
apt-get update && apt-get -y upgrade
/usr/sbin/useradd -s /usr/sbin/nologin $app
# Set up the working directory and app
mkdir /opt/$app && chown $app /opt/$app
cp /tmp/$app /opt/$app/$app
chown $app /opt/$app/$app && chmod 700 /opt/$app/$app
# Enable the systemd unit
systemctl enable $app
