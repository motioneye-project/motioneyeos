SEDLIST="/usr/bin/sed /bin/sed sed gnused gsed"

for SED in $SEDLIST
do
	if ! test -x $SED ; then
		SED=$(which $SED)
		if ! test -x "$SED" > /dev/null ; then
			SED=""
			continue
		fi
	fi

	echo "HELLO" > .sedtest
	$SED -i -e "s/HELLO/GOODBYE/" .sedtest >/dev/null 2>&1
	RESULT=$(cat .sedtest)

	if test $? != 0 ; then
		SED=""
	elif test -e ".sedtest-e" ; then
		rm -f ".sedtest-e"
		SED=""
	elif [ "x$RESULT" = "x" ] || [ "$RESULT" != "GOODBYE" ] > /dev/null ;
	then
		SED=""
	fi

	rm -f .sedtest
	if [ ! -z "$SED" ] ; then
		break
	fi
done
echo $SED
