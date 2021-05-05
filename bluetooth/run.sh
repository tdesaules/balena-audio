#!/bin/ash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --silent --request POST --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" --data '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
    sleep 20
fi

# set env var
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

# replace conf var
sed -i "s/{BLUETOOTH_MAC_ADDRESS}/$BLUETOOTH_MAC_ADDRESS/g" /usr/bin/bluetooth-a2dp-agent
sed -i "s/{BLUETOOTH_PIN_CODE}/$BLUETOOTH_PIN_CODE/g" /usr/bin/bluetooth-a2dp-agent
sed -i "s/{SOUND_RATE}/$SOUND_RATE/g" /etc/asound.conf
sed -i "s/{SOUND_BIT}/$SOUND_BIT/g" /etc/asound.conf
sed -i "s/defaults.pcm.dmix.rate 48000/defaults.pcm.dmix.rate $SOUND_RATE/g" /usr/share/alsa/alsa.conf

# configure bluetooth
bluetoothctl power off
bluetoothctl system-alias $BALENA_DEVICE_NAME_AT_INIT
bluetoothctl set-alias $BALENA_DEVICE_NAME_AT_INIT
bluetoothctl pairable on
bluetoothctl discoverable on
bluetoothctl discoverable-timeout 0
bluetoothctl power on
hciconfig hci0 class 0x200428
hciconfig hci0 sspmode 1

# start
bluetooth-a2dp-agent &
bluealsa --device hci0 --a2dp-force-audio-cd --profile a2dp-sink &
bluealsa-aplay --profile-a2dp --pcm-buffer-time=1000000 00:00:00:00:00:00 &
sleep infinity