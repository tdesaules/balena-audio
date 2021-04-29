#!/bin/ash

# ionstall
apk update
apk upgrade
apk add --no-cache \
    alsa-utils \
    alsa-lib \
    alsa-plugins \
    alsaconf

apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
    snapcast-client

# allow root to use audio
addgroup root audio