#!/bin/sh

# Make sure the host sed supports '-i' (in-place).
# If it doesn't, we'll build and use our own.
SED=$(toolchain/dependencies/check-host-sed.sh)

if [ -z "$SED" ] ; then
	echo build-sed-host-binary
else
	echo use-sed-host-binary
fi
