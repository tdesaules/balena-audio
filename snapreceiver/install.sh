#!/bin/ash

# update and install mandatory package
apk update
apk upgrade
apk add --no-cache \
    jq \
    alsa-utils \
    alsa-lib \
    alsa-plugins \
    alsaconf
apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
    snapcast-client

# allow root to use audio
addgroup root audio

# clean package
apk --purge del