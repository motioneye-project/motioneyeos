################################################################################
#
# rdesktop
#
################################################################################

RDESKTOP_VERSION = 1.8.4
RDESKTOP_SITE = $(call github,rdesktop,rdesktop,v$(RDESKTOP_VERSION))
RDESKTOP_DEPENDENCIES = host-pkgconf openssl xlib_libX11 xlib_libXt \
	$(if $(BR2_PACKAGE_ALSA_LIB_PCM),alsa-lib) \
	$(if $(BR2_PACKAGE_LIBAO),libao) \
	$(if $(BR2_PACKAGE_LIBSAMPLERATE),libsamplerate)
RDESKTOP_CONF_OPTS = --with-openssl=$(STAGING_DIR)/usr --disable-credssp
RDESKTOP_LICENSE = GPL-3.0+
RDESKTOP_LICENSE_FILES = COPYING
# From git
RDESKTOP_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_PCSC_LITE),y)
RDESKTOP_DEPENDENCIES += pcsc-lite
else
RDESKTOP_CONF_OPTS += --disable-smartcard
endif

$(eval $(autotools-package))
