#!/usr/bin/env bash
app=greetings
# Update the OS and add a user
sudo apt-get update && sudo apt-get -y upgrade
sudo /usr/sbin/useradd -s /usr/sbin/nologin $app
# Set up the working directory and app
sudo mkdir /opt/$app && sudo chown $app /opt/$app
sudo cp /tmp/$app /opt/$app/$app
sudo cp /tmp/${app}.service /etc/systemd/system/
sudo chown $app /opt/$app/$app && sudo chmod 700 /opt/$app/$app
# Enable the systemd unit
sudo systemctl enable $app
