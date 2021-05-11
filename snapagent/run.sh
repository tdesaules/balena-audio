#!/bin/ash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --silent --request POST --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" --data '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
    sleep 20
fi

# set env var
export BALENA_HOST_IP=$(curl --silent --request GET --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v1/device?apikey=$BALENA_SUPERVISOR_API_KEY" | jq -r '.ip_address')
export BALENA_HOST_MAC=$(ifconfig wlan0 2>/dev/null | awk '/HWaddr/ {print $5}' | tr '[:upper:]' '[:lower:]')

# replace conf var
sed -i "s/defaults.pcm.dmix.rate 48000/defaults.pcm.dmix.rate $SOUND_RATE/g" /usr/share/alsa/alsa.conf
for ROOM in $(echo $SOURCES | jq -r '.[] | select(.name=="bluetooth")' | jq -r '.rooms[]')
do
echo "
pcm.file_bluetooth_${ROOM} {
    type file
    slave.pcm null
    file /var/cache/snapcast/bluetooth_${ROOM}
    format raw
}
pcm.bluetooth_${ROOM} {
    type rate
    slave {
        pcm file_bluetooth_${ROOM}
        format S${SOUD_BIT}_LE
        rate $SOUND_RATE
    }
}
" >> /etc/asound.conf
done

# start snapcast client
for ROOM in $(echo $SOURCES | jq -r '.[] | select(.name=="bluetooth")' | jq -r '.rooms[]')
do
    for CLIENT_IP in $(curl --silent --request GET --header "Content-Type:application/json" --header "Authorization: Bearer $TOKEN_API" "https://api.balena-cloud.com/v6/device" | jq '.d[] | select(.device_name!="master")' | jq -r '.ip_address')
    do
        echo "snapclient --host $CLIENT_IP --soundcard $ROOM &"
    done
done

# don't stop the container if something crash
sleep infinity