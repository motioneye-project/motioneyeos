#!/bin/sh

if [ -z "$TARGET" ]; then
    echo "this script must be invoked from postscript.sh"
    exit 1
fi

# disable startup scripts
rm -f $TARGET/etc/init.d/S01logging
rm -f $TARGET/etc/init.d/S15watchdog
rm -f $TARGET/etc/init.d/S49ntp
rm -f $TARGET/etc/init.d/S50proftpd
rm -f $TARGET/etc/init.d/S20urandom
rm -f $TARGET/etc/init.d/S80dhcp-relay
rm -f $TARGET/etc/init.d/S80dhcp-server

