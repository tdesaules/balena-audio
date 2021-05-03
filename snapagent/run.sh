#!/bin/ash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --silent --request POST --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" --data '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
    sleep 15
fi

# set env var
export BALENA_HOST_IP=$(curl --silent --request GET --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v1/device?apikey=$BALENA_SUPERVISOR_API_KEY" | jq -r '.ip_address')
export BALENA_HOST_MAC=$(ifconfig wlan0 2>/dev/null | awk '/HWaddr/ {print $5}' | tr '[:upper:]' '[:lower:]')

# replace conf var
sed -i "s/{SOUND_RATE}/$SOUND_RATE/g" /etc/asound.conf
sed -i "s/{SOUND_BIT}/$SOUND_BIT/g" /etc/asound.conf

# start snapcast client
snapclient --host 192.168.100.153 --soundcard salon &

# sleep a few sec to let time to connect client to server before changing name
sleep 3
# set client name
curl --silent --request POST --header "Content-Type:application/json" "http://192.168.100.153:1780/jsonrpc" --data "{\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"Client.SetName\",\"params\":{\"id\":\"$BALENA_HOST_MAC\",\"name\":\"$BALENA_DEVICE_NAME_AT_INIT\"}}" | jq

# don't stop the container if something crash
sleep infinity