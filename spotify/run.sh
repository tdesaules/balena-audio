#!/bin/ash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --silent --request POST --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" --data '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
    sleep 30
fi

for ROOM in $(echo $SOURCES | jq -r '.[] | select(.name=="spotify")' | jq -r '.rooms[]')
do
    # start spotify
    librespot --name $ROOM --backend pipe --device /var/cache/snapcast/spotify_$ROOM --cache /var/cache/spotify --bitrate 320 --format S$SOUND_BIT --device-type speaker --enable-volume-normalisation --initial-volume 50 &
done

sleep infinity