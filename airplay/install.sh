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
apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    shairport-sync

# clean package
apk --purge del