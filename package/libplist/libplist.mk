################################################################################
#
# libplist
#
################################################################################

LIBPLIST_VERSION = 1.12
LIBPLIST_SOURCE = libplist-$(LIBPLIST_VERSION).tar.bz2
LIBPLIST_SITE = http://www.libimobiledevice.org/downloads
LIBPLIST_DEPENDENCIES = libxml2 host-pkgconf
LIBPLIST_INSTALL_STAGING = YES
LIBPLIST_LICENSE = LGPL-2.1+
LIBPLIST_LICENSE_FILES = COPYING

# Straight out of the git tree:
LIBPLIST_AUTORECONF = YES

# Disable building Python bindings, because it requires host-cython, which
# is not packaged in Buildroot at all.
LIBPLIST_CONF_OPTS = --without-cython

$(eval $(autotools-package))
