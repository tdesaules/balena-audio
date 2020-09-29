#!/bin/ash

# install dependencies
apk add --no-cache \
    alsa-utils \
    alsa-lib \
    alsa-plugins \
    alsaconf
#apk add --no-cache -X hhttp://dl-cdn.alpinelinux.org/alpine/edge/main \
apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
    snapcast
#apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \

# allow root to use audio
addgroup root audio