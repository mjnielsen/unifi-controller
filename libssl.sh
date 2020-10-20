#!/bin/bash

ARCH=$(uname -m)

if [ $ARCH == 'x86_64' ]
then
  wget http://launchpadlibrarian.net/362321150/libssl1.0.0_1.0.2n-1ubuntu5_amd64.deb 
  dpkg -i libssl1.0.0_1.0.2n-1ubuntu5_amd64.deb
elif [ $ARCH == 'aarch64' ]
then
  wget https://launchpad.net/ubuntu/+source/openssl1.0/1.0.2n-1ubuntu5/+build/14503127/+files/libssl1.0.0_1.0.2n-1ubuntu5_arm64.deb
  dpkg -i libssl1.0.0_1.0.2n-1ubuntu5_arm64.deb
fi
