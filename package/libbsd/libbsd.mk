################################################################################
#
# libbsd
#
################################################################################

LIBBSD_VERSION         = 0.4.2
LIBBSD_SOURCE          = libbsd-$(LIBBSD_VERSION).tar.gz
LIBBSD_SITE            = http://libbsd.freedesktop.org/releases
LIBBSD_LICENSE         = BSD-3c MIT
LIBBSD_LICENSE_FILES   = COPYING

# man-pages are BSD-4c, so that license only matters
# if doc is kept in the target rootfs
ifeq ($(BR2_HAVE_DOCUMENTATION),y)
LIBBSD_LICENSE        += (libraries), BSD-4c (documentation)
endif

LIBBSD_INSTALL_STAGING = YES

$(eval $(autotools-package))
