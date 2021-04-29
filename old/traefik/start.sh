#!/bin/ash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" -d '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
fi

# set env var
export BALENA_HOST_IP=$(curl -X GET --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v1/device?apikey=$BALENA_SUPERVISOR_API_KEY" | jq -r '.ip_address')
export BALENA_HOST_MAC=$(ifconfig wlan0 2>/dev/null | awk '/HWaddr/ {print $5}' | tr '[:upper:]' '[:lower:]')
if [ "$SUBDOMAIN" == "none" ] ; then
    export SUBDOMAIN=$BALENA_DEVICE_NAME_AT_INIT
fi

# replace conf var
find /etc/traefik -type f -name '*.yaml' | xargs sed -i "s/%%DOMAIN%%/$DOMAIN/g"
find /etc/traefik -type f -name '*.yaml' | xargs sed -i "s/%%SUBDOMAIN%%/$SUBDOMAIN/g"
find /etc/traefik -type f -name '*.yaml' | xargs sed -i "s/%%BALENA_HOST_IP%%/$BALENA_HOST_IP/g"

# start
/usr/bin/traefik &
sleep infinity