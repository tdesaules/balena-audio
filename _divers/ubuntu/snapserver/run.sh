#!/bin/bash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" -d '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
fi

# set env var
export BALENA_HOST_IP=$(curl -X GET --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v1/device?apikey=$BALENA_SUPERVISOR_API_KEY" | jq -r '.ip_address')
export BALENA_HOST_MAC=$(ifconfig wlan0 2>/dev/null | awk '/HWaddr/ {print $5}' | tr '[:upper:]' '[:lower:]')

# replace conf var
for STREAM in $(echo $SOURCES | jq -r '.[].name')
do
    echo "stream = pipe:///var/cache/snapcast/$STREAM?name=$STREAM&codec=pcm&sampleformat={SNAPCAST_RATE}:{SNAPCAST_BIT}:2" >> /etc/snapserver.conf
done
sed -i "s/{SNAPCAST_RATE}/$SNAPCAST_RATE/g" /etc/snapserver.conf
sed -i "s/{SNAPCAST_BIT}/$SNAPCAST_BIT/g" /etc/snapserver.conf

# start snapcast server
snapserver &

# don't stop the container if something crash
sleep infinity