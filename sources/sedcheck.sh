#!/bin/sh

if [ -x /usr/bin/sed ]; then 
    SED="/usr/bin/sed";
else
    if [ -x /bin/sed ]; then 
	SED="/bin/sed";
    fi;
fi;

echo "HELLO" > .sedtest
$SED -i -e "s/HELLO/GOODBYE/" .sedtest >/dev/null 2>&1

if [ $? != 0 ] ; then
	rm -f .sedtest
	echo build-sed-host-binary
fi;
rm -f .sedtest
echo use-sed-host-binary


