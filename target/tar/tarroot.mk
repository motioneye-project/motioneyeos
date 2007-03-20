#############################################################
#
# tar to archive target filesystem
#
#############################################################

TAR_OPTS:=$(strip $(BR2_TARGET_ROOTFS_TAR_OPTIONS))
TAR_TARGET:=$(IMAGE).tar

TAR_COMPRESSOR:=
TAR_COMPRESSOR_EXT:=.none
ifeq ($(BR2_TARGET_ROOTFS_TAR_GZIP),y)
TAR_COMPRESSOR:=gzip -9 -c
TAR_COMPRESSOR_EXT:=gz
endif
ifeq ($(BR2_TARGET_ROOTFS_TAR_BZIP2),y)
TAR_COMPRESSOR:=bzip2 -9 -c
TAR_COMPRESSOR_EXT:=bz2
endif
ifeq ($(BR2_TARGET_ROOTFS_TAR_LZMA),y)
TAR_COMPRESSOR:=lzma -9 -c
TAR_COMPRESSOR_EXT:=lzma
endif

tarroot: host-fakeroot makedevs
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIP) 2>/dev/null || true;
	@rm -rf $(TARGET_DIR)/usr/man
	@rm -rf $(TARGET_DIR)/usr/info
	-/sbin/ldconfig -r $(TARGET_DIR) 2>/dev/null
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	touch $(STAGING_DIR)/.fakeroot.00000
	cat $(STAGING_DIR)/.fakeroot* > $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(STAGING_DIR)/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
endif
	# Use fakeroot so tar believes the previous fakery
	echo "tar -c$(TAR_OPTS)f $(TAR_TARGET) -C $(TARGET_DIR) ." \
		>> $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	chmod a+x $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	$(STAGING_DIR)/usr/bin/fakeroot -- $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
ifneq ($(TAR_COMPRESSOR),)
	-rm -f $(TAR_TARGET).$()
	PATH="$(STAGING_DIR)/sbin:$(STAGING_DIR)/bin:$(STAGING_DIR)/usr/sbin:$(STAGING_DIR)/usr/bin:$(PATH)" $(TAR_COMPRESSOR) $(TAR_TARGET) > $(TAR_TARGET).$(TAR_COMPRESSOR_EXT)
endif
	-@rm -f $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))

tarroot-source:

tarroot-clean:

tarroot-dirclean:

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_TARGET_ROOTFS_TAR)),y)
TARGETS+=tarroot
endif
