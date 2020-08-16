################################################################################
#
# libiberty
#
################################################################################

LIBIBERTY_VERSION = 2.32
LIBIBERTY_SOURCE = binutils-$(LIBIBERTY_VERSION).tar.xz
LIBIBERTY_SITE = $(BR2_GNU_MIRROR)/binutils
HOST_LIBIBERTY_DL_SUBDIR = binutils

# We're only building libiberty here, not the full binutils suite
LIBIBERTY_LICENSE = LGPL-2.1+
LIBIBERTY_LICENSE_FILES = COPYING.LIB

LIBIBERTY_SUBDIR = libiberty

# We explicitly disable multilib, as we do in binutils.
# By default, libiberty installs nothing, so we must force it.
HOST_LIBIBERTY_CONF_OPTS = \
	--disable-multilib \
	--enable-install-libiberty

# Some packages (e.g. host-gdb) will pick this library and build shared
# objects with it. But libiberty does not honour the --enable-shared and
# --disable-static flags; it only ever builds a static library no matter
# what. So we must force -fPIC in build flags.
HOST_LIBIBERTY_CONF_ENV = \
	CFLAGS="$(HOST_CFLAGS) -fPIC" \
	LDFLAGS="$(HOST_LDFLAGS) -fPIC"

$(eval $(host-autotools-package))
