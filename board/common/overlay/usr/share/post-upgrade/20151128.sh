#!/bin/bash

# option "thumbnailer_interval" has been removed from motionEye config

grep -v 'thumbnailer_interval' /data/etc/motioneye.conf > /tmp/motioneye.conf
mv /tmp/motioneye.conf /data/etc/

