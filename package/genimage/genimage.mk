################################################################################
#
# genimage
#
################################################################################

GENIMAGE_VERSION        = 4
GENIMAGE_SOURCE         = genimage-$(GENIMAGE_VERSION).tar.xz
GENIMAGE_SITE           = http://www.pengutronix.de/software/genimage/download/
GENIMAGE_DEPENDENCIES   = host-pkgconf libconfuse
GENIMAGE_LICENSE        = GPLv2

$(eval $(host-autotools-package))
