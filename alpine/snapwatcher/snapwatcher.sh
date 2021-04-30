#!/bin/bash

unset STREAM_STATUS
declare -A STREAM_STATUS

# infinite loop to deamonize
while true
do
    # reset hash
    STREAM_STATUS=()
    # retrieve info over snapcast server to get the current status
    RESPONSE=$(echo '{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}' | nc -w 1 $SNAPSERVER_HOST 1705)
    # for all stream detected create an hash with status for all stream
    for STREAM in $(echo $RESPONSE | jq -r '.result.server.streams[].id')
    do
        # get status playing or idle 
        STATUS=$(echo $RESPONSE | jq -r ".result.server.streams[] | select(.id==\"$STREAM\")" | jq -r '.status')
        # populate hash with stream name and status
        STREAM_STATUS[$STREAM]=$STATUS
    done
    # for all strem retrieve
    for STREAM in "${!STREAM_STATUS[@]}"
    do
        # if the stream is playing song
        if [ ${STREAM_STATUS[$STREAM]} == "playing" ]
        then
            # retrieve member defined in balena cloud json variable to connect client to stream
            MEMBERS=$(echo $STREAMS | jq -r ".[] | select (.name==\"$STREAM\")" | jq -r '.members[]')
            # for each member
            for MEMBER in $MEMBERS
            do
                # retrieve the group id where the client is (a group is in fact a association between a strem and a client)
                ID=$(echo $RESPONSE | jq -r ".result.server.groups[] | select (.clients[].config.name==\"$MEMBER\")" | jq -r '.id')
                CLIENT_STREAM=$(echo "{\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"Group.GetStatus\",\"params\":{\"id\":\"$ID\"}}" | nc -w 1 $SNAPSERVER_HOST 1705 | jq -r '.result.group.stream_id')
                # if name defined in the client is the same as the stream : we play localy bedroom device with bedroom stream
                if [ $MEMBER == $STREAM ] && [ $CLIENT_STREAM != $STREAM ]
                then
                    # associate the stream playing to the local device
                    NEW_CLIENT_STREAM=$(echo "{\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"Group.SetStream\",\"params\":{\"id\":\"$ID\",\"stream_id\":\"$STREAM\"}}" | nc -w 1 $SNAPSERVER_HOST 1705 | jq -r '.result.stream_id')
                    echo "device $MEMBER attach to stream $STREAM"
                fi
                # if stream name is different from the device name so we play a multiroom stream
                # we also check that the client is not playing a local song (local is more important than multiroom)
                if [ $MEMBER != $STREAM ] && [ "${STREAM_STATUS[$MEMBER]}" != "playing" ] && [ $CLIENT_STREAM != $STREAM ]
                then
                    # associate the stream playing to the local device
                    NEW_CLIENT_STREAM=$(echo "{\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"Group.SetStream\",\"params\":{\"id\":\"$ID\",\"stream_id\":\"$STREAM\"}}" | nc -w 1 $SNAPSERVER_HOST 1705 | jq -r '.result.stream_id')
                    echo "device $MEMBER attach to stream $STREAM"
                fi
            done
        fi
    done
done