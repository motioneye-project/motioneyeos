#############################################################
#
# fontconfig
#
#############################################################
FONTCONFIG_VERSION = 2.6.0
FONTCONFIG_SOURCE = fontconfig-$(FONTCONFIG_VERSION).tar.gz
FONTCONFIG_SITE = http://fontconfig.org/release
FONTCONFIG_LICENSE = fontconfig license
FONTCONFIG_LICENSE_FILES = COPYING
FONTCONFIG_AUTORECONF = YES
FONTCONFIG_INSTALL_STAGING = YES
# This package does not like using the target cflags for some reason.
FONTCONFIG_CONF_ENV = CFLAGS="-I$(STAGING_DIR)/usr/include/freetype2"

FONTCONFIG_CONF_OPT = --with-arch=$(GNU_TARGET_NAME) \
		--with-freetype-config="$(STAGING_DIR)/usr/bin/freetype-config" \
		--with-cache-dir=/var/cache/fontconfig \
		--with-expat="$(STAGING_DIR)/usr/lib" \
		--with-expat-lib=$(STAGING_DIR)/usr/lib \
		--with-expat-includes=$(STAGING_DIR)/usr/include \
		--disable-docs

FONTCONFIG_DEPENDENCIES = freetype expat

HOST_FONTCONFIG_CONF_OPT = \
		--disable-docs \
		--disable-static

$(eval $(autotools-package))
$(eval $(host-autotools-package))
