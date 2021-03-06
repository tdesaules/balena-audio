#!/bin/ash

# add edge repositories
echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
echo "@edgecommunity http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# update and install mandatory package
apk update
apk upgrade
apk add --no-cache \
    jq \
    alsa-utils \
    alsa-lib \
    alsa-lib-dev \
    alsa-plugins \
    alsaconf \
    git \
    rust@edge \
    cargo@edgecommunity

# export some env var
export CARGO_NET_GIT_FETCH_WITH_CLI=true

# build librespot binbary
URL="https://github.com/librespot-org/librespot/archive/refs/tags/$(curl --silent --request GET --header "Content-Type:application/json" "https://api.github.com/repos/librespot-org/librespot/git/refs/tags" | jq -r '.[-1].ref' | cut -d '/' -f 3).zip"
wget $URL --output-document "/tmp/librespot.zip" --quiet
unzip "/tmp/librespot.zip" -d "/opt"
cd /opt/$(ls /opt/ | grep librespot*)
cargo build --release --no-default-features --quiet
mv /opt/$(ls /opt/ | grep librespot*)/target/release /opt/librespot
ln -s /opt/librespot/librespot /usr/bin/librespot

# clean source
rm -rf /tmp/librespot.zip
rm -rf /opt/librespot-*
# clean package
apk --purge del \
    alsa-lib-dev \
    git \
    cargo