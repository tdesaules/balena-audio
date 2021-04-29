#!/bin/ash

# add edge repo dangerous
#echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
#echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
#echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# check update
apk update
apk upgrade
apk add --no-cache \
    jq