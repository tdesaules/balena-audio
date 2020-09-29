#!/bin/ash

# install dependencies
apk add --no-cache \
    alsa-utils \
    alsa-lib \
    alsa-lib-dev \
    alsa-plugins \
    alsaconf \
    cargo

# install librespot build with cargo
cd /tmp
wget -O librespot.zip https://github.com/librespot-org/librespot/archive/v0.1.1.zip
unzip /tmp/librespot.zip
cd /tmp/librespot-0.1.1
cargo build --release --no-default-features --features alsa-backend
mv /tmp/librespot-0.1.1/target/release /opt/librespot
ln -s /opt/librespot/librespot /usr/bin/librespot

# clean
rm -rf /tmp/librespot*
rm -rf /tmp/cargo*

# remove package
apk --purge del \
    alsa-lib-dev \
    cargo