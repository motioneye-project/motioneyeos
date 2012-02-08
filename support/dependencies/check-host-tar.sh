#!/bin/sh

candidate="$1"

tar=`which $candidate`
if [ ! -x "$tar" ]; then
	tar=`which tar`
	if [ ! -x "$tar" ]; then
		# echo nothing: no suitable tar found
		exit 1
	fi
fi

# Output of 'tar --version' examples:
# tar (GNU tar) 1.15.1
# tar (GNU tar) 1.25
version=`$tar --version | head -n 1 | sed 's/^.*\s\([0-9]\+\.\S\+\).*$/\1/'`
major=`echo "$version" | cut -d. -f1`
minor=`echo "$version" | cut -d. -f2`
bugfix=`echo "$version" | cut -d. -f3`

# Minimal version = 1.17 (previous versions do not correctly unpack archives
# containing hard-links if the --strip-components option is used).
major_min=1
minor_min=17
if [ $major -gt $major_min ]; then
	echo $tar
else
	if [ $major -eq $major_min -a $minor -ge $minor_min ]; then
		echo $tar
	else
		# echo nothing: no suitable tar found
		exit 1
	fi
fi
