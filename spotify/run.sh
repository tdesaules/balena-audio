#!/bin/ash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --silent --request POST --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" --data '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
    sleep 20
fi

# set env var
export BALENA_HOST_IP=$(curl --silent --request GET --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v1/device?apikey=$BALENA_SUPERVISOR_API_KEY" | jq -r '.ip_address')
export BALENA_HOST_MAC=$(ifconfig wlan0 2>/dev/null | awk '/HWaddr/ {print $5}' | tr '[:upper:]' '[:lower:]')

for STREAM in $(echo $STREAMS | jq -r '.[] | select(.name=="spotify")' | jq -r '.streams[]')
do
    # start spotify
    librespot --name $STREAM --backend pipe --device /var/cache/snapcast/spotify_$STREAM --cache /var/cache/spotify --bitrate 320 --device-type speaker --enable-volume-normalisation --initial-volume 50 &
done

sleep infinity