#!/bin/sh
#

killall matchbox-keyboard
if [ ! $? -eq 0 ] 
then
    matchbox-keyboard &
fi
