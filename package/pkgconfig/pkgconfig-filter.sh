#!/bin/bash
# filter the output from pkg-config (renamed as pkg-config.real)
# and ensures PKG_CONFIG_SYSROOT is prepended to all paths

CMD=$0

if [ ! "$PKG_CONFIG_SYSROOT" ]; then
	echo "pkg-config-filter: missing \$PKG_CONFIG_SYSROOT environment variable"
	exit 2
fi

export PKG_CONFIG_LIBDIR
export PKG_CONFIG_PATH

if $CMD.real $* |
	sed -e "s~\-L/*$PKG_CONFIG_SYSROOT/*~-L=/~g; s~\-I/*$PKG_CONFIG_SYSROOT/*~-I=/~g;" |
	sed -e "s~\-L/~-L=/~g; s~\-I/~-I=/~g;" |
	sed -e "s~\-L\=~-L$PKG_CONFIG_SYSROOT~g; s~\-I\=~-I$PKG_CONFIG_SYSROOT~g;"
then
	#echo "PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR" >&2
	#echo "PKG_CONFIG_PATH=$PKG_CONFIG_PATH" >&2
	#echo "OKAY" >&2;
	exit 0;
else
	echo "pkg-config failed!" >&2
	exit $?
fi
