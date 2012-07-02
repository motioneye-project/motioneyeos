################################################################################
#
# wavpack
#
################################################################################

WAVPACK_VERSION = 4.60.1
WAVPACK_SITE = http://www.wavpack.com
WAVPACK_SOURCE = wavpack-$(WAVPACK_VERSION).tar.bz2
WAVPACK_INSTALL_STAGING = YES

ifneq ($(BR2_ENABLE_LOCALE),y)
WAVPACK_DEPENDENCIES += libiconv
endif

$(eval $(autotools-package))
