################################################################################
#
# libbsd
#
################################################################################

LIBBSD_VERSION = 0.8.2
LIBBSD_SOURCE = libbsd-$(LIBBSD_VERSION).tar.xz
LIBBSD_SITE = http://libbsd.freedesktop.org/releases
LIBBSD_LICENSE = BSD-3c, MIT
LIBBSD_LICENSE_FILES = COPYING
LIBBSD_INSTALL_STAGING = YES
# For 0001-build-clock_gettime-might-need-librt.patch
LIBBSD_AUTORECONF = YES

$(eval $(autotools-package))
