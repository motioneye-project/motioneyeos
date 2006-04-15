#!/bin/sh

# Make sure the host sed supports '-i' (in-place).
# If it doesn't, we'll build and use our own.

if test -x /usr/bin/sed ; then
	SED="/usr/bin/sed"
else
	if test -x /bin/sed ; then
		SED="/bin/sed"
	else
		SED="sed"
	fi
fi

echo "HELLO" > .sedtest
$SED -i -e "s/HELLO/GOODBYE/" .sedtest >/dev/null 2>&1

if test $? != 0 ; then
	echo build-sed-host-binary
else
	echo use-sed-host-binary
fi

rm -f .sedtest
