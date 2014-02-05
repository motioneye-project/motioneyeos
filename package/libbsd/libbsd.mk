################################################################################
#
# libbsd
#
################################################################################

LIBBSD_VERSION         = 0.4.2
LIBBSD_SITE            = http://libbsd.freedesktop.org/releases
LIBBSD_LICENSE         = BSD-3c MIT
LIBBSD_LICENSE_FILES   = COPYING

LIBBSD_INSTALL_STAGING = YES

$(eval $(autotools-package))
