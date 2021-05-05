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
    alsa-utils \
    alsa-utils-doc \
    alsa-lib \
    alsa-plugins \
    alsaconf \
    python3 \
    py3-dbus \
    py3-gobject3 \
    fdk-aac \
    bluez-alsa \
    bluez@edge \
    bluez-btmon@edge
    bluez-deprecated@edge

# allow root to use audio
addgroup root audio

# clean package
apk --purge del