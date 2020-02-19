################################################################################
#
# brltty
#
################################################################################

BRLTTY_VERSION = 6.0
BRLTTY_SOURCE = brltty-$(BRLTTY_VERSION).tar.xz
BRLTTY_SITE = http://brltty.com/archive
BRLTTY_INSTALL_STAGING_OPTS = INSTALL_ROOT=$(STAGING_DIR) install
BRLTTY_INSTALL_TARGET_OPTS = INSTALL_ROOT=$(TARGET_DIR) install
BRLTTY_LICENSE = LGPL-2.1+
BRLTTY_LICENSE_FILES = LICENSE-LGPL README

BRLTTY_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES) host-autoconf host-pkgconf \
	$(if $(BR2_PACKAGE_AT_SPI2_CORE),at-spi2-core)

BRLTTY_CONF_ENV = \
	PKG_CONFIG_FOR_BUILD=$(HOST_DIR)/bin/pkgconf

BRLTTY_CONF_OPTS = \
	--disable-java-bindings \
	--disable-lisp-bindings \
	--disable-ocaml-bindings \
	--disable-python-bindings \
	--disable-tcl-bindings \
	--disable-x \
	--without-espeak-ng \
	--without-midi-package \
	--without-mikropuhe --without-speechd --without-swift \
	--without-theta

# Autoreconf is needed because we're patching configure.ac in
# 0001-Fix-linking-error-on-mips64el. However, a plain autoreconf doesn't work,
# because this package is only autoconf-based.
define BRLTTY_AUTOCONF
	cd $(BRLTTY_SRCDIR) && $(AUTOCONF)
endef

BRLTTY_PRE_CONFIGURE_HOOKS += BRLTTY_AUTOCONF

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS),y)
BRLTTY_DEPENDENCIES += bluez5_utils
BRLTTY_CONF_OPTS += --with-bluetooth-package
else
BRLTTY_CONF_OPTS += --without-bluetooth-package
endif

ifeq ($(BR2_PACKAGE_ESPEAK),y)
BRLTTY_DEPENDENCIES += espeak
BRLTTY_CONF_OPTS += --with-espeak=$(TARGET_DIR)/usr
else
BRLTTY_CONF_OPTS += --without-espeak
endif

ifeq ($(BR2_PACKAGE_EXPAT),y)
# host-expat is needed by tbl2hex's host program
BRLTTY_DEPENDENCIES += host-expat expat
BRLTTY_CONF_OPTS += --enable-expat
else
BRLTTY_CONF_OPTS += --disable-expat
endif

ifeq ($(BR2_PACKAGE_FLITE),y)
BRLTTY_DEPENDENCIES += flite
BRLTTY_CONF_OPTS += --with-flite=$(STAGING_DIR)/usr
else
BRLTTY_CONF_OPTS += --without-flite
endif

ifeq ($(BR2_PACKAGE_ICU),y)
BRLTTY_DEPENDENCIES += icu
BRLTTY_CONF_OPTS += --enable-icu
else
BRLTTY_CONF_OPTS += --disable-icu
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
BRLTTY_DEPENDENCIES += ncurses
BRLTTY_CONF_OPTS += --with-curses
else
BRLTTY_CONF_OPTS += --without-curses
endif

ifeq ($(BR2_PACKAGE_PCRE2_32),y)
BRLTTY_DEPENDENCIES += pcre2
BRLTTY_CONF_OPTS += --with-rgx-package
else ifeq ($(BR2_PACKAGE_PCRE_32),y)
BRLTTY_DEPENDENCIES += pcre
BRLTTY_CONF_OPTS += --with-rgx-package
else
BRLTTY_CONF_OPTS += --without-rgx-package
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
BRLTTY_DEPENDENCIES += systemd
BRLTTY_CONF_OPTS += --with-service-package
else
BRLTTY_CONF_OPTS += --without-service-package
endif

ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
BRLTTY_CONF_OPTS += --enable-i18n
else
BRLTTY_CONF_OPTS += --disable-i18n
endif

BRLTTY_TEXT_TABLE = $(call qstrip,$(BR2_PACKAGE_BRLTTY_TEXT_TABLE))
ifneq ($(BRLTTY_TEXT_TABLE),)
BRLTTY_CONF_OPTS += --with-text-table=$(BRLTTY_TEXT_TABLE)
endif

define BRLTTY_INSTALL_CONF
	$(INSTALL) -D -m 644 $(@D)/Documents/brltty.conf $(TARGET_DIR)/etc/brltty.conf
endef

BRLTTY_POST_INSTALL_TARGET_HOOKS += BRLTTY_INSTALL_CONF

define BRLTTY_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/brltty/S10brltty \
		   $(TARGET_DIR)/etc/init.d/S10brltty
endef

define BRLTTY_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/brltty/brltty.service \
		   $(TARGET_DIR)/usr/lib/systemd/system/brltty.service
endef

$(eval $(autotools-package))
