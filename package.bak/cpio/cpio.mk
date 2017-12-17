################################################################################
#
# cpio
#
################################################################################

CPIO_VERSION = 2.12
CPIO_SITE = $(BR2_GNU_MIRROR)/cpio
CPIO_CONF_OPTS = --bindir=/bin
CPIO_DEPENDENCIES = $(if $(BR2_PACKAGE_BUSYBOX),busybox)
CPIO_LICENSE = GPLv3+
CPIO_LICENSE_FILES = COPYING

# cpio uses argp.h which is not provided by uclibc or musl by default.
# Use the argp-standalone package to provide this.
ifeq ($(BR2_PACKAGE_ARGP_STANDALONE),y)
CPIO_DEPENDENCIES += argp-standalone
endif

$(eval $(autotools-package))
