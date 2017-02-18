#!/bin/sh

candidate="$1" #ignored

asciidoc=`which asciidoc`
if [ ! -x "$asciidoc" ]; then
	# echo nothing: no suitable asciidoc found
	exit 1
fi

# Output of 'asciidoc --version' examples:
# asciidoc 8.6.7
version=`$asciidoc --version | cut -d\  -f2`
major=`echo "$version" | cut -d. -f1`
minor=`echo "$version" | cut -d. -f2`
bugfix=`echo "$version" | cut -d. -f3`

# To generate the manual, we need asciidoc >= 8.6.3
major_min=8
minor_min=6
bugfix_min=3
if [ $major -gt $major_min ]; then
	echo $asciidoc
else
	if [ $major -eq $major_min -a $minor -ge $minor_min ]; then
		echo $asciidoc
	else
		if [ $major -eq $major_min -a $minor -eq $minor_min \
			-a $bugfix -ge $bugfix_min ]; then
			echo $asciidoc
		else
			# echo nothing: no suitable asciidoc found
			exit 1
		fi
	fi
fi
