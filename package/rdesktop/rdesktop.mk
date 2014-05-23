################################################################################
#
# rdesktop
#
################################################################################

RDESKTOP_VERSION = 1.8.2
RDESKTOP_SITE = http://downloads.sourceforge.net/project/rdesktop/rdesktop/$(RDESKTOP_VERSION)
RDESKTOP_DEPENDENCIES = host-pkgconf openssl xlib_libX11 xlib_libXt \
	$(if $(BR2_PACKAGE_ALSA_LIB_PCM),alsa-lib) \
	$(if $(BR2_PACKAGE_LIBAO),libao) \
	$(if $(BR2_PACKAGE_LIBSAMPLERATE),libsamplerate)
RDESKTOP_CONF_OPT = --with-openssl=$(STAGING_DIR)/usr --disable-credssp
RDESKTOP_LICENSE = GPLv3+
RDESKTOP_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_PCSC_LITE),y)
RDESKTOP_DEPENDENCIES += pcsc-lite
else
RDESKTOP_CONF_OPT += --disable-smartcard
endif

$(eval $(autotools-package))
