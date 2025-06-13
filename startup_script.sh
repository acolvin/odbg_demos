#!/bin/bash

##  Create Oracle user, install packages
sudo useradd -m -s /bin/bash oracle
sudo apt-get -o DPkg::Lock::Timeout=600 -y install unzip
sudo ln -s /usr/lib/x86_64-linux-gnu/libaio.so.1t64 /usr/lib/x86_64-linux-gnu/libaio.so.1

curl -o /tmp/oracle-setup.sh -O https://storage.googleapis.com/oracle-partner-demo-bucket/startup-scripts/oracle-setup.sh

sudo -u oracle bash -x /tmp/oracle-setup.sh
