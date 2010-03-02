#############################################################
#
# Build the cramfs root filesystem image
#
#############################################################
ifeq ($(BR2_ENDIAN),"BIG")
CRAMFS_OPTS=-b
else
CRAMFS_OPTS=-l
endif

ifneq ($(TARGET_DEVICE_TABLE),)
CRAMFS_OPTS += -D $(TARGET_DEVICE_TABLE)
endif

CRAMFS_TARGET=$(IMAGE).cramfs

cramfsroot: host-fakeroot host-cramfs makedevs
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))
	touch $(BUILD_DIR)/.fakeroot.00000
	cat $(BUILD_DIR)/.fakeroot* > $(BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(HOST_DIR)/usr/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))
endif
	# Use fakeroot so mkcramfs believes the previous fakery
	echo "$(HOST_DIR)/usr/bin/mkcramfs -q $(CRAMFS_OPTS) " \
		"$(TARGET_DIR) $(CRAMFS_TARGET)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))
	chmod a+x $(BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))
	$(HOST_DIR)/usr/bin/fakeroot -- $(BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))
	-@rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_ROOTFS_CRAMFS),y)
TARGETS+=cramfsroot
endif
