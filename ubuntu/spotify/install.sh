#!/bin/bash

# check update
apt update
DEBIAN_FRONTEND=noninteractive apt upgrade --yes --no-install-recommends
DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends \
    wget \
    jq \
    libasound2 \
    libasound2-dev \
    pkg-config \
    alsa-utils \
    alsa-tools \
    build-essential \
    unzip \
    cargo

# allow root to use audio
addgroup root audio

# install librespot build with cargo
URL="https://github.com/librespot-org/librespot/archive/refs/tags/$(curl --header "Content-Type:application/json" "https://api.github.com/repos/librespot-org/librespot/git/refs/tags" --silent | jq -r '.[-1].ref' | cut -d '/' -f 3).zip"
wget $URL --output-document "/tmp/librespot.zip" --quiet
unzip "/tmp/librespot.zip" -d "/opt"
cd /opt/$(ls /opt/ | grep librespot*)
cargo build --release --no-default-features --quiet
mv /opt/$(ls /opt/ | grep librespot*)/target/release /opt/librespot
ln -s /opt/librespot/librespot /usr/bin/librespot

# clean
rm -rf /tmp/librespot.zip
rm -rf /opt/librespot-*
apt remove --yes cargo libasound2-dev build-essential pkg-config
apt autoremove --yes
apt clean --yes