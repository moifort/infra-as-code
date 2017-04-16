#! /bin/sh

# Install desired plugins
cat /root/.homebridge/plugins.txt | xargs npm install -g --unsafe-perm

# Start service
homebridge
