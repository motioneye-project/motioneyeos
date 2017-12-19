################################################################################
#
# libplist
#
################################################################################

LIBPLIST_VERSION = 2.0.0
LIBPLIST_SOURCE = libplist-$(LIBPLIST_VERSION).tar.bz2
LIBPLIST_SITE = http://www.libimobiledevice.org/downloads
LIBPLIST_INSTALL_STAGING = YES
LIBPLIST_LICENSE = LGPL-2.1+
LIBPLIST_LICENSE_FILES = COPYING

# Disable building Python bindings, because it requires host-cython, which
# is not packaged in Buildroot at all.
LIBPLIST_CONF_OPTS = --without-cython

$(eval $(autotools-package))
