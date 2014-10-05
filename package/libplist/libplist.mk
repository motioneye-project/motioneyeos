################################################################################
#
# libplist
#
################################################################################

LIBPLIST_VERSION = 1.11
LIBPLIST_SITE = http://cgit.sukimashita.com/libplist.git/snapshot
LIBPLIST_DEPENDENCIES = libxml2 host-pkgconf
LIBPLIST_INSTALL_STAGING = YES
LIBPLIST_LICENSE = LGPLv2.1+
LIBPLIST_LICENSE_FILES = COPYING

# Straight out of the git tree:
LIBPLIST_AUTORECONF = YES

# Does not build in parallel
LIBPLIST_MAKE = $(MAKE1)

# Disable building Python bindings, because it requires host-cython, which
# is not packaged in Buildroot at all.
LIBPLIST_CONF_OPTS = --without-cython

$(eval $(autotools-package))
