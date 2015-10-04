#!/bin/sh

if [ -z "$TARGET" ]; then
    echo "this script must be invoked from postscript.sh"
    exit 1
fi

# disable startup scripts
rm -f $TARGET/etc/init.d/S15watchdog # replaced by S02watchdog
rm -f $TARGET/etc/init.d/S49ntp # replaced by S60date
rm -f $TARGET/etc/init.d/S50nginx # not needed
rm -f $TARGET/etc/init.d/S50proftpd # replaced by S70proftpd
rm -f $TARGET/etc/init.d/S20urandom
rm -f $TARGET/etc/init.d/S80dhcp-relay
rm -f $TARGET/etc/init.d/S80dhcp-server

