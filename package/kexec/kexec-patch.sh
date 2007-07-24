#!/bin/bash
SRCDIR=$1
PATCHDIR=$2
PATCHLIST=${PATCHDIR}/$3

do_patch()
{
	cd ${SRCDIR}
	for f in `cat ${PATCHLIST}` ; do
		echo ${PATCHDIR}/$f
		cat ${PATCHDIR}/$f | patch -p2
	done
}

do_patch

