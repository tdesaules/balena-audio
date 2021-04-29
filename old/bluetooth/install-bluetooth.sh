#!/bin/ash

# install dependencies
apk add --no-cache \
    alsa-utils \
    alsa-utils-doc \
    alsa-lib \
    alsaconf \
    python3 \
    py3-dbus \
    py3-gobject3
apk add --no-cache -X hhttp://dl-cdn.alpinelinux.org/alpine/edge/main \
    bluez \
    bluez-btmon \
    bluez-deprecated
apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
    fdk-aac
apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    bluez-alsa