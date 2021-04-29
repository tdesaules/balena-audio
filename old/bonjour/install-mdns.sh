#!/bin/ash

# install dependencies
apk add --no-cache \
    node \
    npm
#apk add --no-cache -X hhttp://dl-cdn.alpinelinux.org/alpine/edge/main \
#apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
#apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \

# install dependencies
mkdir /opt/mdns-server
mv /root/install/mdns-server /opt/mdns-server/mdns-server
chmod +x /opt/mdns-server/mdns-server
cd /opt/mdns-server
npm install bonjour
ln -s /opt/mdns-server/mdns-server /usr/bin/mdns-server