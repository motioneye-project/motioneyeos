#!/bin/sh

# prevent shift error
[ $# -lt 2 ] && exit 1

version_min="$(echo ${1} | awk '{ split($1, v, "."); print v[1] v[2] }')"

shift

# The host python interpreter is already checked by dependencies.sh but
# it only check if the version is at least 2.7.
# We want to check the version number of the python3 interpreter even
# if Buildroot is able to use any version but some packages may require
# a more recent version.

for candidate in "${@}" ; do
	python3=`which $candidate 2>/dev/null`
	if [ ! -x "$python3" ]; then
		continue
	fi
	version=`$python3 -V 2>&1 | awk '{ split($2, v, "."); print v[1] v[2] }'`

	if [ $version -lt $version_min ]; then
		# no suitable python3 found
		continue
	fi

	# suitable python3 found
	echo $python3
	break
done
