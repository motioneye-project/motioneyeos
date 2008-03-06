#############################################################
#
# fontconfig
#
#############################################################
FONTCONFIG_VERSION = 2.4.2
FONTCONFIG_SOURCE = fontconfig-$(FONTCONFIG_VERSION).tar.gz
FONTCONFIG_SITE = http://fontconfig.org/release
FONTCONFIG_AUTORECONF = NO
FONTCONFIG_INSTALL_STAGING = YES
FONTCONFIG_INSTALL_TARGET = YES

FONTCONFIG_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

FONTCONFIG_CONF_OPT = --target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) --with-arch=$(GNU_TARGET_NAME) \
		--prefix=/usr --exec-prefix=/usr \
		--bindir=/usr/bin --sbindir=/usr/sbin \
		--libdir=/usr/lib --libexecdir=/usr/lib \
		--sysconfdir=/etc --datadir=/usr/share \
		--localstatedir=/var --includedir=/usr/include \
		--mandir=/usr/man --infodir=/usr/info \
		--with-freetype-config="$(STAGING_DIR)/usr/bin/freetype-config" \
		--with-expat="$(STAGING_DIR)/usr/lib" \
		--with-expat-lib=$(STAGING_DIR)/usr/lib \
		--with-expat-includes=$(STAGING_DIR)/usr/include \
		--disable-docs 

FONTCONFIG_DEPENDENCIES = uclibc freetype expat

$(eval $(call AUTOTARGETS,package,fontconfig))
