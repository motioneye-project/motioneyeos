#!/bin/sh
# no simulated network devices at the moment
rm -f ${TARGET_DIR}/etc/init.d/S40network
rm -rf ${TARGET_DIR}/etc/network/
