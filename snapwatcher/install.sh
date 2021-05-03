#!/bin/ash

# update and install mandatory package
apk update
apk upgrade
apk add --no-cache \
    jq \
    inotify-tools

# create a link for the watcher bin
ln -s /root/snapwatcher.sh /usr/bin/snapwatcher

# clean package
apk --purge del