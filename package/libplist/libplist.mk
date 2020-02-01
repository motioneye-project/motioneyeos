################################################################################
#
# libplist
#
################################################################################

LIBPLIST_VERSION = 2.1.0
LIBPLIST_SITE = $(call github,libimobiledevice,libplist,$(LIBPLIST_VERSION))
LIBPLIST_INSTALL_STAGING = YES
LIBPLIST_LICENSE = LGPL-2.1+
LIBPLIST_LICENSE_FILES = COPYING
# github tarball does not include configure
LIBPLIST_AUTORECONF = YES

# Disable building Python bindings, because it requires host-cython, which
# is not packaged in Buildroot at all.
LIBPLIST_CONF_OPTS = --without-cython

$(eval $(autotools-package))
