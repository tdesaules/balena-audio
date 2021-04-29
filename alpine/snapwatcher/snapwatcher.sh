#!/bin/ash

inotifywait -r -m -e modify $1 | while read
do 
    echo "$1 play music"
    sleep 5
done