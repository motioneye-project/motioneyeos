#!/bin/sh

candidate="$1"

lzip=`which $candidate 2>/dev/null`
if [ ! -x "$lzip" ]; then
	lzip=`which lzip 2>/dev/null`
	if [ ! -x "$lzip" ]; then
		# echo nothing: no suitable lzip found
		exit 1
	fi
fi

echo $lzip
