################################################################################
#
# tn5250
#
################################################################################

TN5250_VERSION = 0.17.4
TN5250_SITE = http://downloads.sourceforge.net/project/tn5250/tn5250/$(TN5250_VERSION)
TN5250_MAKE_OPTS = CPPFLAGS=""
TN5250_DEPENDENCIES = ncurses
TN5250_LICENSE = LGPLv2.1+
TN5250_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_OPENSSL),y)
TN5250_CONF_OPTS += --with-ssl-dir=$(STAGING_DIR)/usr
TN5250_CONF_ENV += LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs openssl`"
TN5250_DEPENDENCIES += openssl host-pkgconf
else
TN5250_CONF_OPTS += --without-ssl
endif

define TN5250_INSTALL_FIXES
	rm -f $(TARGET_DIR)/usr/bin/5250keys
	rm -f $(TARGET_DIR)/usr/bin/xt5250
endef

TN5250_POST_INSTALL_TARGET_HOOKS += TN5250_INSTALL_FIXES

$(eval $(autotools-package))
