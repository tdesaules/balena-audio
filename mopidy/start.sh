#!/bin/ash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" -d '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
fi

# set env var
export BALENA_HOST_IP=$(curl -X GET --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v1/device?apikey=$BALENA_SUPERVISOR_API_KEY" | jq -r '.ip_address')
export BALENA_HOST_MAC=$(ifconfig wlan0 2>/dev/null | awk '/HWaddr/ {print $5}' | tr '[:upper:]' '[:lower:]')

# replace conf var
sed -i "s/{SNAPCAST_RATE}/$SNAPCAST_RATE/g" /root/.config/mopidy/mopidy.conf
sed -i "s/{SNAPCAST_BIT}/$SNAPCAST_BIT/g" /root/.config/mopidy/mopidy.conf

# workaround for lib /usr/lib/libpython3.8.so
ln -s /usr/lib/libpython3.so /usr/lib/libpython3.8.so

# start mopidy
mopidy &
sleep infinity