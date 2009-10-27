#############################################################
#
# libidn
#
#############################################################

LIBIDN_VERSION = 1.15
LIBIDN_SITE = http://ftp.gnu.org/gnu/libidn/
LIBIDN_INSTALL_STAGING = YES
LIBIDN_INSTALL_TARGET = YES
LIBIDN_CONF_OPT = --enable-shared --disable-java --enable-csharp=no
LIBIDN_LIBTOOL_PATCH = NO
LIBIDN_DEPENDENCIES = host-pkg-config gettext $(if $(BR2_PACKAGE_LIBICONV),libiconv)

$(eval $(call AUTOTARGETS,package,libidn))

$(LIBIDN_HOOK_POST_INSTALL):
ifneq ($(BR2_PACKAGE_LIBIDN_BINARY),y)
	rm -f $(TARGET_DIR)/usr/bin/idn
endif
	rm -rf $(TARGET_DIR)/usr/share/emacs
	touch $@

$(LIBIDN_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/lib/libidn*
	rm -f $(TARGET_DIR)/usr/bin/idn
	rm -f $(LIBIDN_TARGET_INSTALL_TARGET) $(LIBIDN_HOOK_POST_INSTALL)
