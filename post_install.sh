#!/bin/sh

# Clone source from official MineOS repository
mkdir -p /usr/local/games
git clone git://github.com/hexparrot/mineos-node minecraft || exit
cd minecraft

# Generate Certificates
chmod +x *.sh
./generate-sslcert.sh

# Option #1: Create standard configuration file
# cp mineos.conf /etc/mineos.conf

# Option #2: use http instead of the standard https
sed 's/^use_https.*/use_https = false/' mineos.conf > /etc/mineos.conf


# Build
npm install -g node-gyp node-pre-gyp
echo "CXX=c++ npm install" | sh

# Create user mcserver
pw useradd -n mcserver -u 199 -G games -d /nonexistent -s /usr/local/bin/bash -h 0 <<EOF
mcserver
EOF

# Enable the service
sysrc -f /etc/rc.conf mineos_enable="YES"

# Start the service
service mineos start 2>/dev/null

