#############################################################
#
# libnl
#
#############################################################

LIBNL_VERSION = 1.1
LIBNL_SOURCE = libnl-$(LIBNL_VERSION).tar.gz
LIBNL_SITE = http://distfiles.gentoo.org/distfiles
LIBNL_INSTALL_STAGING = YES
LIBNL_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package,libnl))

$(LIBNL_HOOK_POST_INSTALL): $(LIBNL_TARGET_INSTALL_TARGET)
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libnl.so*
	touch $@

$(LIBNL_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/lib/libnl.so*
	rm -f $(LIBNL_TARGET_INSTALL_TARGET) $(LIBNL_HOOK_POST_INSTALL)
