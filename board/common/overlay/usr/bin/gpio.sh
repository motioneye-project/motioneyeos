#!/bin/bash

GPIO=$1

usage() {
    echo "Usage: $0 <gpio> [0|1]" 1>&2
    exit 1
}

test -z "$GPIO" && usage
test -e /sys/class/gpio/gpio$GPIO || echo $GPIO > /sys/class/gpio/export

if [ -n "$2" ]; then
    echo out > /sys/class/gpio/gpio$GPIO/direction
    echo $2 > /sys/class/gpio/gpio$GPIO/value
else
    echo in > /sys/class/gpio/gpio$GPIO/direction
    cat /sys/class/gpio/gpio$GPIO/value
fi

