#!/bin/bash

/debootstrap/debootstrap --second-stage
apt update
apt upgrade -y
apt-get install wget -y
wget -qO - http://archive.raspberrypi.org/debian/raspberrypi.gpg.key | apt-key add -
echo "deb http://archive.raspberrypi.org/debian/ buster main ui" > /etc/apt/sources.list.d/raspbian.list
apt update
apt-get install libraspberrypi-dev scons build-essential pkg-config libx11-dev libgles2-mesa-dev libasound2-dev libfreetype6-dev libudev-dev libpng-dev zlib1g-dev clang git -y
