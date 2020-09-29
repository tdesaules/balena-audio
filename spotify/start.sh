#!/bin/ash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" -d '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
fi

# set env var
export BALENA_HOST_IP=$(curl -X GET --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v1/device?apikey=$BALENA_SUPERVISOR_API_KEY" | jq -r '.ip_address')
export BALENA_HOST_MAC=$(ifconfig wlan0 2>/dev/null | awk '/HWaddr/ {print $5}' | tr '[:upper:]' '[:lower:]')
if [ "$SPOTIFY_DEVICE_NAME" == "none" ] ; then
    export SPOTIFY_DEVICE_NAME=$BALENA_DEVICE_NAME_AT_INIT
fi

# configure alsa
amixer -M sset PCM,0 $ALSA_VOLUME

# start spotify
librespot \
    --name $SPOTIFY_DEVICE_NAME \
    --backend pipe \
    --device /var/cache/snapcast/snapfifo \
    --cache /var/cache/spotify \
    --bitrate 320 \
    --device-type speaker \
    --username $SPOTIFY_USERNAME \
    --password $SPOTIFY_PASSWORD \
    --enable-volume-normalisation \
    --linear-volume \
    --initial-volume 100 &
sleep infinity