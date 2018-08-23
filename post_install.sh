#!/bin/sh

mkdir -p /usr/local/games
mkdir -p /usr/local/etc/rc.d

# Clone source from official MineOS repository
cd /usr/local/games
git clone git://github.com/hexparrot/mineos-node minecraft 
if [ $? -ne 0 ] ; then
  echo "ERROR: Failed to get source from MineOS Repository"
  exit 1
fi
cd minecraft

# Generate Certificates
chmod +x *.sh
./generate-sslcert.sh

# Option #1: Create standard configuration file
# cp mineos.conf /etc/mineos.conf

# Option #2: use http instead of the standard https
sed 's/^use_https.*/use_https = false/' mineos.conf > /etc/mineos.conf

# Build
echo "CXX=c++ npm install" | sh

# Create user mcserver
pw useradd -n mcserver -u 199 -G games -d /nonexistent -s /usr/local/bin/bash -h 0 <<EOF
mcserver
EOF

# Enable the service
chmod +x /usr/local/etc/rc.d/mineos
sysrc -f /etc/rc.conf mineos_enable="YES"

# Start the service
service mineos start

service mineos status >/dev/null 2>&1
if [ $? -ne 0 ] ; then
  echo "ERROR: Failed to start service"
  exit 1
fi

echo
cat <<EOF
#---------------------------------------------------------------------#
# Getting started with the MineOs plugin
#---------------------------------------------------------------------#

MineOS is a server front-end to ease managing Minecraft administrative tasks.
For more information, see https://github.com/hexparrot/mineos-node

The default logon for the Admin Portal is: mcserver / mcserver
EOF
