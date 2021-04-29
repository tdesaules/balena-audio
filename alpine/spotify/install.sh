#!/bin/ash

# check update
apk update
apk upgrade
apk add --no-cache \
    jq \
    alsa-utils \
    alsa-lib \
    alsa-lib-dev \
    alsa-plugins \
    alsaconf \
    cargo

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
apk --purge del \
    alsa-lib-dev \
    cargo