#!/bin/bash

# convert configuration files to Motion 4.2 directives

for file in /data/etc/{motion,thread-*}.conf; do
    /usr/lib/python2.7/site-packages/motioneye/scripts/migrateconf.sh ${file}
done

