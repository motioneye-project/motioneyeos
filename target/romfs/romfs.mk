#############################################################
#
# Build the romfs root filesystem image
#
#############################################################

ROMFS_TARGET=$(IMAGE).romfs

romfsroot: host-fakeroot host-genromfs makedevs
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(ROMFS_TARGET))
	touch $(BUILD_DIR)/.fakeroot.00000
	cat $(BUILD_DIR)/.fakeroot* > $(BUILD_DIR)/_fakeroot.$(notdir $(ROMFS_TARGET))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(ROMFS_TARGET))
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(HOST_DIR)/usr/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(ROMFS_TARGET))
endif
	# Use fakeroot so genromfs believes the previous fakery
	echo "$(HOST_DIR)/usr/bin/genromfs -d $(TARGET_DIR) -f $(ROMFS_TARGET)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(ROMFS_TARGET))
	chmod a+x $(BUILD_DIR)/_fakeroot.$(notdir $(ROMFS_TARGET))
	$(HOST_DIR)/usr/bin/fakeroot -- $(BUILD_DIR)/_fakeroot.$(notdir $(ROMFS_TARGET))
	-@rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(ROMFS_TARGET))

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_ROOTFS_ROMFS),y)
TARGETS+=romfsroot
endif
