#############################################################
#
# tn5250
#
#############################################################

TN5250_VERSION = 0.17.4
TN5250_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/tn5250
TN5250_MAKE_OPT = CPPFLAGS=""
TN5250_DEPENDENCIES = ncurses

ifeq ($(BR2_PACKAGE_OPENSSL),y)
	TN5250_CONF_OPT += --with-ssl
	TN5250_DEPENDENCIES += openssl
else
	TN5250_CONF_OPT += --without-ssl
endif

$(eval $(call AUTOTARGETS,package,tn5250))

$(TN5250_HOOK_POST_INSTALL):
	rm -f $(TARGET_DIR)/usr/bin/5250keys
	rm -f $(TARGET_DIR)/usr/bin/xt5250
	touch $@

$(TN5250_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	$(MAKE) DESTDIR=$(TARGET_DIR) uninstall -C $(TN5250_DIR)
	rm -f $(TARGET_DIR)/usr/lib/lib5250.*
	rm -rf $(TARGET_DIR)/usr/share/tn5250
	rm -f $(TN5250_TARGET_INSTALL_TARGET) $(TN5250_HOOK_POST_INSTALL)
