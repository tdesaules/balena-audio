#!/bin/ash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --silent --request POST --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" --data '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
    sleep 30
fi

# replace conf var
sed -i "s/{SOUND_CARD}/$SOUND_CARD/g" /etc/asound.conf
sed -i "s/{SOUND_RATE}/$SOUND_RATE/g" /etc/asound.conf
sed -i "s/{SOUND_BIT}/$SOUND_BIT/g" /etc/asound.conf
sed -i "s/defaults.pcm.dmix.rate 48000/defaults.pcm.dmix.rate $SOUND_RATE/g" /usr/share/alsa/alsa.conf

# start snapcast client
snapclient --host $SNAPSERVER_HOST --soundcard $SOUND_CARD &
# start snapcast initilizer
snapinitializer &

# don't stop the container if something crash
sleep infinity