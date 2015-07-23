################################################################################
#
# libtirpc
#
################################################################################

LIBTIRPC_VERSION = 0.3.2
LIBTIRPC_SOURCE = libtirpc-$(LIBTIRPC_VERSION).tar.bz2
LIBTIRPC_SITE = http://downloads.sourceforge.net/project/libtirpc/libtirpc/$(LIBTIRPC_VERSION)
LIBTIRPC_LICENSE = BSD-3c
LIBTIRPC_LICENSE_FILES = COPYING

LIBTIRPC_INSTALL_STAGING = YES
LIBTIRPC_AUTORECONF = YES

# getrpcby{number,name} are only provided if 'GQ' is defined
LIBTIRPC_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -DGQ"

LIBTIRPC_CONF_OPTS = --disable-gssapi

$(eval $(autotools-package))
