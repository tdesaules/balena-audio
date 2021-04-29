#!/bin/ash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" -d '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
fi

# set env var
export BALENA_HOST_IP=$(curl -X GET --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v1/device?apikey=$BALENA_SUPERVISOR_API_KEY" | jq -r '.ip_address')
export BALENA_HOST_MAC=$(ifconfig wlan0 2>/dev/null | awk '/HWaddr/ {print $5}' | tr '[:upper:]' '[:lower:]')

# replace conf var
sed -i "s/{ALSA_SOUNDCARD}/$ALSA_SOUNDCARD/g" /etc/asound.conf
sed -i "s/{SNAPCAST_RATE}/$SNAPCAST_RATE/g" /etc/asound.conf
sed -i "s/{SNAPCAST_BIT}/$SNAPCAST_BIT/g" /etc/asound.conf

# configure alsa
amixer -M sset PCM,0 $ALSA_VOLUME

# start snapcast client
snapclient --host $SNAPSERVER_HOST --soundcard $ALSA_SOUNDCARD &

# sleep a few sec to let time to connect client to server before changing name
sleep 3
# set client name
echo "{\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"Client.SetName\",\"params\":{\"id\":\"$BALENA_HOST_MAC\",\"name\":\"$BALENA_DEVICE_NAME_AT_INIT\"}}" | nc -w 1 127.0.0.1 1705

# don't stop the container if something crash
sleep infinity