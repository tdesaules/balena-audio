#!/bin/ash

# install dependencies
apk add --no-cache \
    nodejs \
    npm
#apk add --no-cache -X hhttp://dl-cdn.alpinelinux.org/alpine/edge/main \
#apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
#apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \

# install dependencies
mv /root/install/manager /opt/manager
cd /opt/manager