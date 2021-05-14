#!/bin/bash

MAC=$(ifconfig wlan0 2>/dev/null | awk '/HWaddr/ {print $5}' | tr '[:upper:]' '[:lower:]')

while true
do
    RESPONSE=$(curl --silent --request POST --header "Content-Type:application/json" "http://$SNAPSERVER_HOST:$SNAPSERVER_PORT/jsonrpc" --data '{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}')
    for GROUP in $(echo $RESPONSE | jq -r '.result.server.groups[].id')
    do
        if [ $(echo $RESPONSE | jq -r ".result.server.groups[] | select(.id==\"$GROUP\")" | jq -r '.clients[].id') == $MAC ]
        then
            if [ ! $(echo $RESPONSE | jq -r ".result.server.groups[] | select(.id==\"$GROUP\")" | jq -r '.clients[].config.name') ]
            then
                curl --silent --request POST --header "Content-Type:application/json" "http://$SNAPSERVER_HOST:$SNAPSERVER_PORT/jsonrpc" --data "{\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"Client.SetName\",\"params\":{\"id\":\"$MAC\",\"name\":\"$BALENA_DEVICE_NAME_AT_INIT\"}}" | jq
                curl --silent --request POST --header "Content-Type:application/json" "http://$SNAPSERVER_HOST:$SNAPSERVER_PORT/jsonrpc" --data "{\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"Group.SetName\",\"params\":{\"id\":\"$GROUP\",\"name\":\"$BALENA_DEVICE_NAME_AT_INIT\"}}" | jq
            fi
        fi
    done
    sleep 15
done