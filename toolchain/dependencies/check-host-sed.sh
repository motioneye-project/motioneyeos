#!/bin/sh

SEDLIST="/usr/bin/sed /bin/sed sed gnused gsed"

for SED in $SEDLIST
do
	if ! test -x $SED ; then
		SED=$(which $SED 2> /dev/null)
		if ! test -x "$SED" > /dev/null ; then
			SED=""
			continue
		fi
	fi

	tmp=$(mktemp)
	echo "HELLO" > $tmp
	$SED -i -e "s/HELLO/GOODBYE/" $tmp >/dev/null 2>&1
	RESULT=$(cat $tmp)

	if test $? != 0 ; then
		SED=""
	elif test -e ".sedtest-e" ; then
		rm -f ".sedtest-e"
		SED=""
	elif [ "x$RESULT" = "x" ] || [ "$RESULT" != "GOODBYE" ] > /dev/null ;
	then
		SED=""
	fi

	rm -f $tmp
	if [ ! -z "$SED" ] ; then
		break
	fi
done
echo $SED
