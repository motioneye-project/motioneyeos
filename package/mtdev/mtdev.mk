################################################################################
#
# mtdev
#
################################################################################

MTDEV_VERSION = 1.1.4
MTDEV_SOURCE = mtdev-$(MTDEV_VERSION).tar.bz2
MTDEV_SITE = http://bitmath.org/code/mtdev/

MTDEV_LICENSE = MIT
MTDEV_LICENSE_FILES = COPYING
MTDEV_INSTALL_STAGING = YES

$(eval $(autotools-package))
