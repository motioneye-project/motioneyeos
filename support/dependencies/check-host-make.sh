#!/bin/sh

# prevent shift error
[ $# -lt 2 ] && exit 1

major_min="${1%.*}"
minor_min="${1#*.}"

shift

# The host make program is already checked by dependencies.sh but we
# want to check the version number even if Buildroot is able to use
# GNU make >= 3.81 but some packages may require a more recent version.
make="$1"

# Output of 'make --version' examples:
# GNU Make 4.2.1
# GNU Make 4.0
# GNU Make 3.81
version=`$make --version 2>&1 | sed -e 's/^.* \([0-9\.]\)/\1/g' -e 's/[-\
].*//g' -e '1q'`

major=`echo "$version" | cut -d. -f1`
minor=`echo "$version" | cut -d. -f2`

if [ $major -lt $major_min ]; then
	# echo nothing: no suitable make found
	exit 1
fi

if [ $major -eq $major_min -a $minor -lt $minor_min ]; then
	# echo nothing: no suitable make found
	exit 1
fi

# valid
echo $make
