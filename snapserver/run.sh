#!/bin/ash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --silent --request POST --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" --data '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
    sleep 30
fi

# set env var
export BALENA_HOST_IP=$(curl --silent --request GET --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v1/device?apikey=$BALENA_SUPERVISOR_API_KEY" | jq -r '.ip_address')
export BALENA_HOST_MAC=$(ifconfig wlan0 2>/dev/null | awk '/HWaddr/ {print $5}' | tr '[:upper:]' '[:lower:]')

# replace conf var
for SOURCE in $(echo $SOURCES | jq -r '.[].name')
do
    for ROOM in $(echo $SOURCES | jq -r ".[] | select(.name==\"$SOURCE\")" | jq -r '.rooms[]')
    do
        STREAMS="${STREAMS}--stream.source pipe:///var/cache/snapcast/${SOURCE}_${ROOM}?name=${SOURCE}_${ROOM}&codec=pcm&sampleformat=${SOUND_RATE}:${SOUND_BIT}:2 "
    done
done

STREAMS="${STREAMS}--stream.source pipe:///var/cache/snapcast/idle?name=idle&codec=pcm&sampleformat=${SOUND_RATE}:${SOUND_BIT}:2"

# start snapcast server
snapserver $STREAMS &

# don't stop the container if something crash
sleep infinity