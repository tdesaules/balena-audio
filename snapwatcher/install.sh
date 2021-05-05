#!/bin/ash

# add edge repositories
echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
echo "@edgecommunity http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# update and install mandatory package
apk update
apk upgrade
apk add --no-cache \
    jq \
    nodejs \
    npm

# install npm dependencies
npm install --global ws

# create a link for the watcher bin
ln -s /root/snapwatcher.sh /usr/bin/snapwatcher

# clean package
apk --purge del