################################################################################
#
# libass
#
################################################################################

LIBASS_VERSION = 0.10.2
LIBASS_SITE = http://libass.googlecode.com/files
LIBASS_INSTALL_STAGING = YES
LIBASS_LICENSE = ISC
LIBASS_LICENSE_FILES = COPYING
LIBASS_DEPENDENCIES = \
	host-pkgconf \
	freetype \
	libfribidi \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
LIBASS_DEPENDENCIES += fontconfig
LIBASS_CONF_OPT += --enable-fontconfig
else
LIBASS_CONF_OPT += --disable-fontconfig
endif

ifeq ($(BR2_PACKAGE_HARFBUZZ),y)
LIBASS_DEPENDENCIES += harfbuzz
LIBASS_CONF_OPT += --enable-harfbuzz
else
LIBASS_CONF_OPT += --disable-harfbuzz
endif

ifeq ($(BR2_PACKAGE_LIBENCA),y)
LIBASS_DEPENDENCIES += libenca
LIBASS_CONF_OPT += --enable-enca
else
LIBASS_CONF_OPT += --disable-enca
endif

$(eval $(autotools-package))
