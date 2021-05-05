#!/bin/ash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --silent --request POST --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" --data '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
    sleep 20
fi

# for all STREAM based on env Balena Cloud STREAMS json list
for STREAM in $(echo $STREAMS | jq -r '.[].name')
do
    
done

# sleep forever to be allowed to access container if crash happen
sleep infinity