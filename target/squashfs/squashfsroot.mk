#############################################################
#
# Build the squashfs root filesystem image
#
#############################################################

SQUASHFS_TARGET:=$(IMAGE).squashfs

squashfsroot: host-fakeroot host-squashfs makedevs
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	touch $(BUILD_DIR)/.fakeroot.00000
	cat $(BUILD_DIR)/.fakeroot* > $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(HOST_DIR)/usr/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
endif
	# Use fakeroot so mksquashfs believes the previous fakery
	echo "$(HOST_DIR)/usr/bin/mksquashfs " \
		    "$(TARGET_DIR) $(SQUASHFS_TARGET) " \
		    "-noappend $(SQUASHFS_ENDIANNESS)" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	chmod a+x $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	$(HOST_DIR)/usr/bin/fakeroot -- $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	chmod 0644 $(SQUASHFS_TARGET)
	-@rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_ROOTFS_SQUASHFS),y)
TARGETS+=squashfsroot
endif
