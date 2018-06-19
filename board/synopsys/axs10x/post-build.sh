#!/bin/sh

set -u
set -e

# Add a console on tty0
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty0::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty0::respawn:/sbin/getty 115200  tty0' ${TARGET_DIR}/etc/inittab
fi
