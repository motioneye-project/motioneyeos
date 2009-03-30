#############################################################
#
# ntfs-3g
#
#############################################################
NTFS_3G_VERSION:=2009.3.8
NTFS_3G_SOURCE:=ntfs-3g-$(NTFS_3G_VERSION).tgz
NTFS_3G_SITE:=http://www.ntfs-3g.org/
NTFS_3G_CONF_OPT:=--disable-ldconfig --program-prefix=""
NTFS_3G_INSTALL_STAGING:=yes

$(eval $(call AUTOTARGETS,package,ntfs-3g))

$(NTFS_3G_TARGET_INSTALL_TARGET): $(NTFS_3G_TARGET_INSTALL_STAGING)
	$(call MESSAGE,"Installing to target")
	cp -dpf $(STAGING_DIR)/usr/lib/libntfs-3g.so* $(TARGET_DIR)/lib/
	$(INSTALL) -m 0755 $(STAGING_DIR)/usr/bin/ntfs-3g $(TARGET_DIR)/bin/
	$(INSTALL) -m 0755 $(STAGING_DIR)/usr/bin/ntfs-3g.probe $(TARGET_DIR)/bin/
	touch $@

ifeq ($(BR2_ENABLE_DEBUG),)
$(NTFS_3G_HOOK_POST_INSTALL): $(NTFS_3G_TARGET_INSTALL_TARGET)
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/bin/ntfs-3g
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/bin/ntfs-3g.probe
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/lib/libntfs-3g.so*
	touch $@
endif

$(NTFS_3G_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(NTFS_3G_DIR) uninstall
	rm -f $(TARGET_DIR)/lib/libntfs-3g*
	rm -f $(TARGET_DIR)/bin/ntfs-3g $(TARGET_DIR)/bin/ntfs-3g.probe
	rm -f $(NTFS_3G_TARGET_INSTALL_STAGING) $(NTFS_3G_TARGET_INSTALL_TARGET) $(NTFS_3G_HOOK_POST_INSTALL)
