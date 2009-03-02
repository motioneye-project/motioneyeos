#############################################################
#
# ntfsprogs
#
#############################################################
NTFSPROGS_VERSION:=2.0.0
NTFSPROGS_SOURCE:=ntfsprogs-$(NTFSPROGS_VERSION).tar.gz
NTFSPROGS_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/linux-ntfs/
NTFSPROGS_CONF_OPT:=--disable-gnome-vfs --program-prefix=""
NTFSPROGS_INSTALL_STAGING:=yes

NTFSPROGS_BIN:=ntfscat ntfscluster ntfscmp ntfsfix ntfsinfo ntfsls
NTFSPROGS_SBIN:=ntfsclone ntfscp ntfslabel ntfsresize ntfsundelete mkntfs

$(eval $(call AUTOTARGETS,package,ntfsprogs))

$(NTFSPROGS_TARGET_INSTALL_TARGET): $(NTFSPROGS_TARGET_INSTALL_STAGING)
	$(call MESSAGE,"Installing to target")
	cp -dpf $(STAGING_DIR)/usr/lib/libntfs.so* $(TARGET_DIR)/usr/lib/
	$(INSTALL) -m 0755 $(addprefix $(STAGING_DIR)/usr/bin/,$(NTFSPROGS_BIN)) $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(addprefix $(STAGING_DIR)/usr/sbin/,$(NTFSPROGS_SBIN)) $(TARGET_DIR)/usr/sbin
	ln -s /usr/sbin/mkntfs $(TARGET_DIR)/sbin/mkfs.ntfs
	touch $@

ifeq ($(BR2_ENABLE_DEBUG),)
$(NTFSPROGS_HOOK_POST_INSTALL): $(NTFSPROGS_TARGET_INSTALL_TARGET)
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/usr/lib/libntfs.so*
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(addprefix $(TARGET_DIR)/usr/bin/,$(NTFSPROGS_BIN))
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(addprefix $(TARGET_DIR)/usr/sbin/,$(NTFSPROGS_SBIN))
	touch $@
endif

$(NTFSPROGS_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(NTFSPROGS_DIR) uninstall
	rm -f $(TARGET_DIR)/usr/lib/libntfs.so*
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,$(NTFSPROGS_BIN))
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/,$(NTFSPROGS_SBIN))
	-unlink $(TARGET_DIR)/sbin/mkfs.ntfs
	rm -f $(NTFSPROGS_TARGET_INSTALL_STAGING) $(NTFSPROGS_TARGET_INSTALL_TARGET) $(NTFSPROGS_HOOK_POST_INSTALL)
