################################################################################
#
# twolame
#
################################################################################

TWOLAME_VERSION = 0.3.13
TWOLAME_SITE = http://downloads.sourceforge.net/project/twolame/twolame/$(TWOLAME_VERSION)
TWOLAME_DEPENDENCIES = host-pkgconf libsndfile
TWOLAME_INSTALL_STAGING = YES
TWOLAME_LICENSE = LGPLv2.1+
TWOLAME_LICENSE_FILES = COPYING

$(eval $(autotools-package))
