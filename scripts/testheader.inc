ARCH=`make -f scripts/test/Makefile ARCH`
DATE=`date +%Y%m%d`
LOGFILE=build-results-${DATE}-${ARCH}.log
function mk()
{
	scripts/mkpkg $1 $2 "$3"			| tee -a ${LOGFILE}
}

function	header()
{
	echo "#!/bin/sh"				| tee -a ${LOGFILE}
	echo "source \"scripts/testheader.inc\""
	
}

active=1
busybox=0

function	SKIP()
{
	echo SKIP					| tee -a ${LOGFILE}
	active=0
}

function	RESTART()
{
	echo RESTART					| tee -a ${LOGFILE}
	active=1
}

function	EXE()
{
	printf 	"EXE	"				| tee -a ${LOGFILE}
	if [ ${active} == 1 ] ; then
		$1 $2 $3 "$4"
		return 0;
	else
		printf	"%-8s"	"$1"			| tee -a ${LOGFILE}
		printf	"%-32s"	"$2"			| tee -a ${LOGFILE}
		printf	"%-16s"	"$3"			| tee -a ${LOGFILE}
		if [ "${4}X" != "X" ] ; then
			printf	"%-64s"	"\"$4\""	| tee -a ${LOGFILE}
		fi
		echo					| tee -a ${LOGFILE}
		return 1;
	fi
}

function	AVR()
{
	printf 	"AVR	"				| tee -a ${LOGFILE}
	if [ "${ARCH}X" == "avr32X" ] ; then
		echo "mk $2 UNSUPPORTED \"$4\" $5 $6"	| tee -a ${LOGFILE}
		return 1;
	elif [ ${active} == 1 ] ; then
		$1 $2 "$3" "$4"
		return 0;
	else
		printf	"%-8s"	"$1"			| tee -a ${LOGFILE}
		printf	"%-32s"	"$2"			| tee -a ${LOGFILE}
		printf	"%-16s"	"$3"			| tee -a ${LOGFILE}
		if [ "${4}X" != "X" ] ; then
			printf	"%-64s"	"\"$4\""	| tee -a ${LOGFILE}
		fi
		echo					| tee -a ${LOGFILE}
		return 1;
	fi
}


function skip()
{
	printf "skip	%-8s" "$1"			| tee -a ${LOGFILE}
	printf "%-32s" "$2"				| tee -a ${LOGFILE}
	if [   "$3X" == "OKX" ] ; then
		printf "%-16s"	"DISABLED"		| tee -a ${LOGFILE}
		if [ "${4}X" != "X" ] ; then
			printf	"%-64s"	"\"$4\""	| tee -a ${LOGFILE}
		fi
	elif [ "$3X" == "FAILX" ] ; then
		printf "%-16s"	"DISABLED"		| tee -a ${LOGFILE}
		if [ "${4}X" != "X" ] ; then
			printf	"%-64s"	"\"$4\""	| tee -a ${LOGFILE}
		fi
	elif [ "$3X" == "BROKENX" ] ; then
		printf "%-16s"	"DISABLED"		| tee -a ${LOGFILE}
		if [ "${4}X" != "X" ] ; then
			printf	"%-64s"	"\"$4\""	| tee -a ${LOGFILE}
		fi
	elif [ "$3X" == "DISABLEDX" ] ; then
		printf "%-16s"	"DISABLED"		| tee -a ${LOGFILE}
		if [ "${4}X" != "X" ] ; then
			printf	"%-64s"	"\"$4\""	| tee -a ${LOGFILE}
		fi
	else
		printf "%-16s"	"DISABLED" 		| tee -a ${LOGFILE}
		if [ "${4}X" != "X" ] ; then
			printf	"%-64s"	"\"$4\""	| tee -a ${LOGFILE}
		fi
	fi
	echo						| tee -a ${LOGFILE}
}

function bb()
{
	printf 	"%-8s"	"bb"				| tee -a ${LOGFILE}
	if [ ${busybox} == 1 ] ; then
		printf "%-8s"	"$1"			| tee -a ${LOGFILE}
		$1 $2 $3 $4 $5 $6
		return 0;
	else
		echo "$1	$2 $3 $4 $5 $6"		| tee -a ${LOGFILE}
		return 1;
	fi
}

function	comment()
{
	echo	"comment	$1"			| tee -a ${LOGFILE}
}

# Enable HASERL
sed -i s/.*BR2_PACKAGE_HASERL.*// .config
echo "# BR2_PACKAGE_HASERL_VERSION_0_8_X is not set" >> .config
echo "BR2_PACKAGE_HASERL_VERSION_0_9_X=y" >> .config
echo "BR2_PACKAGE_HASERL_VERSION=\"0.9.25\"" >> .config
echo "BR2_PACKAGE_HASERL=y" >> .config
# Enable SSL
sed -i s/.*BR2_PACKAGE_OPENSSL.*// .config
echo "BR2_PACKAGE_OPENSSL=y" >> .config
# Enable socat
sed -i s/.*BR2_PACKAGE_SOCAT.*// .config
echo "BR2_PACKAGE_SOCAT=y" >> .config
echo "BR2_PACKAGE_SOCAT_PREDEF_CRDLY_SHIFT=\"9\"" >> .config
echo "BR2_PACKAGE_SOCAT_PREDEF_TABDLY_SHIFT=\"11\"" >> .config
echo "BR2_PACKAGE_SOCAT_PREDEF_CSIZE_SHIFT=\"4\"" >> .config
# Enable Freetype
sed -i s/.*BR2_PACKAGE_FREETYPE.*// .config
echo "BR2_PACKAGE_FREETYPE=y" >> .config
sed -i s/.*BR2_FREETYPE_VERSION.*// .config
echo "# BR2_FREETYPE_VERSION_2_2_1 is not set" >> .config
echo "BR2_FREETYPE_VERSION_2_3_7=y" >> .config
echo "BR2_FREETYPE_VERSION=\"2.3.7\"" >> .config

