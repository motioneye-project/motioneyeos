################################################################################
#
# libbsd
#
################################################################################

LIBBSD_VERSION = 0.6.0
LIBBSD_SOURCE = libbsd-$(LIBBSD_VERSION).tar.xz
LIBBSD_SITE = http://libbsd.freedesktop.org/releases
LIBBSD_LICENSE = BSD-3c MIT
LIBBSD_LICENSE_FILES = COPYING

LIBBSD_INSTALL_STAGING = YES

$(eval $(autotools-package))
