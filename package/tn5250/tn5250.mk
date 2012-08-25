#############################################################
#
# tn5250
#
#############################################################

TN5250_VERSION = 0.17.4
TN5250_SITE = http://downloads.sourceforge.net/project/tn5250/tn5250/$(TN5250_VERSION)
TN5250_MAKE_OPT = CPPFLAGS=""
TN5250_DEPENDENCIES = ncurses

ifeq ($(BR2_PACKAGE_OPENSSL),y)
	TN5250_CONF_OPT += --with-ssl
	TN5250_DEPENDENCIES += openssl
else
	TN5250_CONF_OPT += --without-ssl
endif

define TN5250_INSTALL_FIXES
	rm -f $(TARGET_DIR)/usr/bin/5250keys
	rm -f $(TARGET_DIR)/usr/bin/xt5250
endef

TN5250_POST_INSTALL_TARGET_HOOKS += TN5250_INSTALL_FIXES

define TN5250_UNINSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) uninstall -C $(TN5250_DIR)
	rm -f $(TARGET_DIR)/usr/lib/lib5250.*
	rm -rf $(TARGET_DIR)/usr/share/tn5250
endef

$(eval $(autotools-package))
