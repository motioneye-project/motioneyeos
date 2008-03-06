#!/bin/sh

	STAGING_DIR=$1

	# fix the fontutil pkgconfig file to cross-compile fonts after fontutil is installed
	sed "s,^mapdir=.*,mapdir=${STAGING_DIR}/usr/lib/X11/fonts/util,g" \
		${STAGING_DIR}/usr/lib/pkgconfig/fontutil.pc > ${STAGING_DIR}/usr/lib/pkgconfig/fontutil.pc.new
	mv ${STAGING_DIR}/usr/lib/pkgconfig/fontutil.pc.new ${STAGING_DIR}/usr/lib/pkgconfig/fontutil.pc
	
	# link to the build host's ucs2any and fc-cache  
	rm ${STAGING_DIR}/usr/bin/ucs2any 

	ln -s `which ucs2any` ${STAGING_DIR}/usr/bin
	if [ "$?" != "0" ]; then
		echo "Error linking to the build host's ucs2any font utility."
		echo "Make sure that you have the xorg-x11-font-utils package installed."
		exit 1
	fi

	rm ${STAGING_DIR}/usr/bin/fc-cache

	ln -s `which fc-cache` ${STAGING_DIR}/usr/bin
	if [ "$?" != "0" ]; then
		echo "Error linking to the build host's fc-cache font utility."
		echo "Make sure that you have the fontconfig package installed."
		exit 1
	fi

