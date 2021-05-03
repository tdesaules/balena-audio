#!/bin/ash

# install gstreamer dependencies and python and other
apk add --no-cache \
    musl \
    musl-dev \
    busybox \
    gcc \
    libffi \
    libffi-dev \
    gstreamer \
    gst-plugins-base \
    gst-plugins-good \
    gst-plugins-bad \
    gst-plugins-ugly \
    py3-gst \
    py3-libxml2 \
    py3-pykka \
    py3-requests \
    py3-setuptools \
    py3-six \
    py3-tornado \
    py3-cffi \
    python3 \
    python3-dev
#apk add --no-cache -X hhttp://dl-cdn.alpinelinux.org/alpine/edge/main \
apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
    py3-pip
#apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \

# install mopidy softs and plugins
pip3 install --upgrade --no-cache-dir \
    pip \
    mopidy \
    Mopidy-Iris \
    Mopidy-Youtube

# remove useless soft
apk del \
    musl-dev \
    gcc \
    libffi-dev \
    python3-dev \
    py3-pip