################################################################################
#
# twolame
#
################################################################################

TWOLAME_VERSION = 0.4.0
TWOLAME_SITE = http://downloads.sourceforge.net/project/twolame/twolame/$(TWOLAME_VERSION)
TWOLAME_INSTALL_STAGING = YES
TWOLAME_LICENSE = LGPL-2.1+
TWOLAME_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
TWOLAME_DEPENDENCIES += host-pkgconf libsndfile
TWOLAME_CONF_OPTS += --enable-sndfile
else
TWOLAME_CONF_OPTS += --disable-sndfile
endif

$(eval $(autotools-package))
