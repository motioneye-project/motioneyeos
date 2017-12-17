################################################################################
#
# libbsd
#
################################################################################

LIBBSD_VERSION = 0.8.3
LIBBSD_SOURCE = libbsd-$(LIBBSD_VERSION).tar.xz
LIBBSD_SITE = http://libbsd.freedesktop.org/releases
LIBBSD_LICENSE = BSD-3-Clause, MIT
LIBBSD_LICENSE_FILES = COPYING
LIBBSD_INSTALL_STAGING = YES

$(eval $(autotools-package))
