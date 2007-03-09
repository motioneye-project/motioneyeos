SEDLIST="/usr/bin/sed /bin/sed sed gnused gsed"

DIFF=$(which diff)
if ! test -x "$DIFF" ; then
	/bin/echo -e "\n\ntesting for sed needs 'diff' on your build machine\n";
	exit 1;
fi;

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
	echo "GOODBYE" > .sedtest-correct
	$SED -i -e "s/HELLO/GOODBYE/" .sedtest >/dev/null 2>&1

	if test $? != 0 ; then
		SED=""
	elif test -e ".sedtest-e" ; then
		rm -f ".sedtest-e"
		SED=""
	elif ! $DIFF ".sedtest" ".sedtest-correct" > /dev/null ; then
		echo "diff failed"
		SED=""
	fi

	rm -f .sedtest .sedtest-correct
	if [ ! -z "$SED" ] ; then
		break
	fi
done
echo $SED
