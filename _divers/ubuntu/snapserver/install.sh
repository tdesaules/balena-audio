#!/bin/bash

# check update
apt update
DEBIAN_FRONTEND=noninteractive apt upgrade --yes --no-install-recommends
DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends \
    wget \
    jq \
    libasound2 \
    pkg-config \
    alsa-utils \
    alsa-tools

URL=$(curl --header "Content-Type:application/json" "https://api.github.com/repos/badaix/snapcast/releases/latest" --silent | jq -r '.assets[] | select(.name? | match("snapserver_.*_armhf.deb"))' | jq -r '.browser_download_url')
wget $URL --output-document "/tmp/snapcast_server.deb" --quiet
dpkg --install /tmp/snapcast_server.deb

# clean
rm -rf /tmp/snapcast_server.deb
apt autoremove --yes
apt clean --yes