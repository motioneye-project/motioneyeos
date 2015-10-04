#!/bin/sh

# Debug script to determine proper ES revision for the current board. The
# pvrsrvkm module must be insmoded before attempting to get the es rev.

machine_id() { # return the machine ID
	awk 'BEGIN { FS=": " } /Hardware/ \
		{ gsub(" ", "_", $2); print tolower($2) } ' </proc/cpuinfo
}

if [ "$(machine_id)" = "ti8168evm" ] ; then
	CPUTYPE=TI816x
elif [ "$(machine_id)" = "am335xevm" ] ; then
	CPUTYPE=TI33XX
else
	CPUTYPE=$(devmem 0x4800244c | sed -e 's/0x00005C00/OMAP3503/' \
	                                  -e 's/0x00001C00/OMAP3515/' \
	                                  -e 's/0x00004C00/OMAP3525/' \
	                                  -e 's/0x00000C00/OMAP3530/' \
	                                  -e 's/0x00005E00/OMAP3503/' \
	                                  -e 's/0x00001E00/OMAP3515/' \
	                                  -e 's/0x00004E00/OMAP3525/' \
	                                  -e 's/0x00000E00/OMAP3530/' \
	                                  -e 's/0x00000CC0/OMAP3530/' )
	if [[ "$(echo $CPUTYPE | grep OMAP)" == "" ]]; then
		echo "Unable to determine CPU type"
		exit 1
	fi
fi

case $CPUTYPE in
"OMAP3530")
	devmem 0x48004B48 w 0x2
	devmem 0x48004B10 w 0x1
	devmem 0x48004B00 w 0x2

	ES_REVISION="$(devmem 0x50000014 | sed -e s:0x00010205:5: \
		-e s:0x00010201:3: -e s:0x00010003:2:)"
	;;
"TI33XX")
	devmem 0x44e01104 w 0x0
	devmem 0x44e00904 w 0x2

	ES_REVISION="$(devmem 0x56000014 | sed -e s:0x00010205:8:)"
	;;
"TI816x")
	devmem 0x48180F04 w 0x0
	devmem 0x48180900 w 0x2
	devmem 0x48180920 w 0x2

	ES_REVISION="$(devmem2 0x56000014 | sed -e s:0x00010205:6: -e s:0x00010201:3: -e s:0x00010003:2: | tail -n1 | awk -F': ' '{print $2}')"
	;;
*)
	echo Unable to determine SGX hardware
	exit 2
	;;
esac

echo $ES_REVISION
