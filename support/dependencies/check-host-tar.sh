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
# bsdtar 2.8.3 - libarchive 2.8.3
version=`$tar --version | head -n 1 | sed 's/^.*\s\([0-9]\+\.\S\+\).*$/\1/'`
major=`echo "$version" | cut -d. -f1`
minor=`echo "$version" | cut -d. -f2`
bugfix=`echo "$version" | cut -d. -f3`
version_bsd=`$tar --version | grep 'bsdtar'`
if [ ! -z "${version_bsd}" ] ; then 
  # mark as invalid version - not all command line options are available
  major=0
  minor=0
fi

# Minimal version = 1.27 (previous versions do not correctly unpack archives
# containing hard-links if the --strip-components option is used or create
# different gnu long link headers for path elements > 100 characters).
major_min=1
minor_min=27

# Maximal version = 1.29 (1.30 changed --numeric-owner output for
# filenames > 100 characters). This is really a fix for a bug in
# earlier tar versions regarding deterministic output so it is
# unlikely to be reverted in later versions.
major_max=1
minor_max=29

if [ $major -lt $major_min -o $major -gt $major_max ]; then
	# echo nothing: no suitable tar found
	exit 1
fi

if [ $major -eq $major_min -a $minor -lt $minor_min ]; then
	# echo nothing: no suitable tar found
	exit 1
fi

if [ $major -eq $major_max -a $minor -gt $minor_max ]; then
	# echo nothing: no suitable tar found
	exit 1
fi

# valid
echo $tar
