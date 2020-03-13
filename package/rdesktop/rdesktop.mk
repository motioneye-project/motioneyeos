################################################################################
#
# rdesktop
#
################################################################################

RDESKTOP_VERSION = 1.9.0
RDESKTOP_SITE = \
	https://github.com/rdesktop/rdesktop/releases/download/v$(RDESKTOP_VERSION)
RDESKTOP_DEPENDENCIES = \
	host-pkgconf \
	gnutls \
	libtasn1 \
	nettle \
	xlib_libX11 \
	xlib_libXcursor \
	xlib_libXt \
	$(if $(BR2_PACKAGE_ALSA_LIB_PCM),alsa-lib) \
	$(if $(BR2_PACKAGE_LIBAO),libao) \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv) \
	$(if $(BR2_PACKAGE_LIBSAMPLERATE),libsamplerate) \
	$(if $(BR2_PACKAGE_PULSEAUDIO),pulseaudio) \
	$(if $(BR2_PACKAGE_XLIB_LIBXRANDR),xlib_libXrandr)
RDESKTOP_CONF_OPTS = --disable-credssp
RDESKTOP_LICENSE = GPL-3.0+
RDESKTOP_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_PCSC_LITE),y)
RDESKTOP_DEPENDENCIES += pcsc-lite
else
RDESKTOP_CONF_OPTS += --disable-smartcard
endif

$(eval $(autotools-package))
