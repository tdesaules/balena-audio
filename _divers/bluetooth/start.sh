#!/bin/ash

# if tag to be stop then exit it
if [ "$IS_STARTED" != "true" ] ; then
    curl --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" -d '{"serviceName": "'$BALENA_SERVICE_NAME'"}'
fi

# set env var
export BALENA_HOST_IP=$(curl -X GET --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v1/device?apikey=$BALENA_SUPERVISOR_API_KEY" | jq -r '.ip_address')
export BALENA_HOST_MAC=$(ifconfig wlan0 2>/dev/null | awk '/HWaddr/ {print $5}' | tr '[:upper:]' '[:lower:]')
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
if [ "$BLUETOOTH_DEVICE_NAME" == "none" ] ; then
    export BLUETOOTH_DEVICE_NAME=$BALENA_DEVICE_NAME_AT_INIT
fi

# replace conf var
sed -i "s/%%BLUETOOTH_MAC_ADDRESS%%/$BLUETOOTH_MAC_ADDRESS/g" /usr/bin/bluetooth-a2dp-agent
sed -i "s/%%BLUETOOTH_PIN_CODE%%/$BLUETOOTH_PIN_CODE/g" /usr/bin/bluetooth-a2dp-agent
sed -i "s/%%SNAPCAST_RATE%%/$SNAPCAST_RATE/g" /etc/asound.conf
sed -i "s/%%SNAPCAST_BIT%%/$SNAPCAST_BIT/g" /etc/asound.conf

# configure bluetooth
bluetoothctl power off
bluetoothctl system-alias $BLUETOOTH_DEVICE_NAME
bluetoothctl set-alias $BLUETOOTH_DEVICE_NAME
bluetoothctl pairable on
bluetoothctl discoverable on
bluetoothctl discoverable-timeout 0
bluetoothctl power on
hciconfig hci0 class 0x200428
hciconfig hci0 sspmode 1

# configure alsa
amixer -M sset PCM,0 $ALSA_VOLUME

# start
/usr/bin/bluetooth-a2dp-agent &
/usr/bin/bluealsa -i hci0 -p a2dp-sink &
/usr/bin/bluealsa-aplay --profile-a2dp --pcm-buffer-time=1000000 00:00:00:00:00:00 &
sleep infinity