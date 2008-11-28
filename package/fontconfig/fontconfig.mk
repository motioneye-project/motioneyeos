#############################################################
#
# fontconfig
#
#############################################################
FONTCONFIG_VERSION = 2.6.0
FONTCONFIG_SOURCE = fontconfig-$(FONTCONFIG_VERSION).tar.gz
FONTCONFIG_SITE = http://fontconfig.org/release
FONTCONFIG_AUTORECONF = YES
FONTCONFIG_USE_CONFIG_CACHE = NO
FONTCONFIG_INSTALL_STAGING = YES
FONTCONFIG_INSTALL_TARGET = YES
# This package does not like using the target cflags for some reason.
FONTCONFIG_CONF_ENV = CFLAGS=

FONTCONFIG_CONF_OPT = --with-arch=$(GNU_TARGET_NAME) \
		--with-freetype-config="$(STAGING_DIR)/usr/bin/freetype-config" \
		--with-expat="$(STAGING_DIR)/usr/lib" \
		--with-expat-lib=$(STAGING_DIR)/usr/lib \
		--with-expat-includes=$(STAGING_DIR)/usr/include \
		--disable-docs

FONTCONFIG_DEPENDENCIES = uclibc freetype expat

$(eval $(call AUTOTARGETS,package,fontconfig))
