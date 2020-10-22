#!/bin/sh

mkdir -p /usr/local/games
mkdir -p /usr/local/etc/rc.d

# Remove previous MineOS install
if [ -d "/usr/local/games/minecraft" ] ; then
  rm -rf /usr/local/games/minecraft
fi

# Clone source from official MineOS repository
cd /usr/local/games
git clone git://github.com/hexparrot/mineos-node --quiet --depth 1 minecraft
if [ $? -ne 0 ] ; then
  echo "ERROR: Failed to get source from MineOS Repository"
  exit 1
fi
cd minecraft

# Generate Certificates
chmod +x *.sh
if [ ! -f "/etc/ssl/certs/mineos.crt" ] ; then 
  ./generate-sslcert.sh > /dev/null 2>&1
fi
echo

# Create configuration file
if [ ! -f "/etc/mineos.conf" ] ; then
  # Option #1: Create standard configuration file
  # cp mineos.conf /etc/mineos.conf
  # Option #2: use http instead of the standard https
  sed 's/^use_https.*/use_https = false/' mineos.conf > /etc/mineos.conf
fi

# Install patched version of node-userid
npm install jsegaert/node-userid

# Build
echo "CXX=c++ npm install" | sh

# Create user mcserver
pw useradd -n mcserver -u 199 -G games -d /nonexistent -s /usr/local/bin/bash -h 0 <<EOF
mcserver
EOF

# Enable the service
chmod +x *.sh
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
cat <<EOF > /root/PLUGIN_INFO
#---------------------------------------------------------------------#
# Getting started with the MineOs plugin
#---------------------------------------------------------------------#

MineOS is a server front-end to ease managing Minecraft administrative tasks.
For more information, see https://github.com/hexparrot/mineos-node

The default user for the Admin Portal is "mcserver" with password "mcserver"
EOF

cat /root/PLUGIN_INFO
