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
888b     d888 d8b                    .d88888b.   .d8888b.
8888b   d8888 Y8P                   d88P" "Y88b d88P  Y88b
88888b.d88888                       888     888 Y88b.
888Y88888P888 888 88888b.   .d88b.  888     888  "Y888b.
888 Y888P 888 888 888 "88b d8P  Y8b 888     888     "Y88b.
888  Y8P  888 888 888  888 88888888 888     888       "888
888   "   888 888 888  888 Y8b.     Y88b. .d88P Y88b  d88P
888       888 888 888  888  "Y8888   "Y88888P"   "Y8888P"

MineOS is a server front-end to ease managing Minecraft administrative tasks.
For more info, see https://github.com/hexparrot/mineos-node

The default logon for the Admin Portal is: mcserver / mcserver
EOF
