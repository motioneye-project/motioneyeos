################################################################################
#
# genimage
#
################################################################################

GENIMAGE_VERSION = 9
GENIMAGE_SOURCE = genimage-$(GENIMAGE_VERSION).tar.xz
GENIMAGE_SITE = http://www.pengutronix.de/software/genimage/download
HOST_GENIMAGE_DEPENDENCIES = host-pkgconf host-libconfuse
GENIMAGE_LICENSE = GPLv2
GENIMAGE_LICENSE_FILES = COPYING

$(eval $(host-autotools-package))
