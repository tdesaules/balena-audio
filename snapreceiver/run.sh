#!/bin/ash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --silent --request POST --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" --data '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
    sleep 20
fi

# for each AUDIO_SOURCES defined in balena cloud anv variable json
for AUDIO_SOURCE in $(echo $AUDIO_SOURCES | jq -r '.[].name')
do
    # build a string with the stream options for snapserver based on balena cloud env variables
    STREAM_SOURCE="${STREAM_SOURCE}--stream.source pipe:///var/cache/snapcast/$AUDIO_SOURCE?name=$AUDIO_SOURCE&codec=pcm&sampleformat=$SOUND_RATE:$SOUND_BIT:2 "
done

# start snapcast server
snapserver $STREAM_SOURCE &

# sleep forever to be allowed to access container if crash happen
sleep infinity