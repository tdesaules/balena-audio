#!/bin/ash

# check update
apk update
apk upgrade
apk add --no-cache \
    jq \
    inotify-tools

ln -s /root/snapwatcher.sh /usr/bin/snapwatcher