#!/bin/ash

# install dependencies
#apk add --no-cache \
#apk add --no-cache -X hhttp://dl-cdn.alpinelinux.org/alpine/edge/main \
#apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
#apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \

# install dependencies
mkdir /root/install/traefik
cd /root/install/traefik
echo "rpi : $BALENA_DEVICE_TYPE"
if [ "$BALENA_DEVICE_TYPE" == "raspberrypi3" ] ; then
    wget -O traefik.tar.gz https://github.com/containous/traefik/releases/download/v2.2.1/traefik_v2.2.1_linux_armv7.tar.gz
fi
if [ "$BALENA_DEVICE_TYPE" == "raspberrypi3-64" ] || [ "$BALENA_DEVICE_TYPE" == "raspberrypi4-64" ] ; then
    wget -O traefik.tar.gz https://github.com/containous/traefik/releases/download/v2.2.1/traefik_v2.2.1_linux_arm64.tar.gz
fi
tar -zxvf traefik.tar.gz
mv /root/install/traefik/traefik /usr/bin/traefik