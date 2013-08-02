#!/bin/sh

candidate="$1"

xzcat=`which $candidate 2>/dev/null`
if [ ! -x "$xzcat" ]; then
	xzcat=`which xzcat 2>/dev/null`
	if [ ! -x "$xzcat" ]; then
		# echo nothing: no suitable xzcat found
		exit 1
	fi
fi

echo $xzcat
