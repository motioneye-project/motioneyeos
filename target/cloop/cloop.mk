#############################################################
#
# Build the compressed loop root filesystem image
#
#############################################################

CLOOP_TARGET=$(IMAGE).cloop
CLOOP_FAKEROOT_SCRIPT=$(BUILD_DIR)/_fakeroot.$(notdir $(CLOOP_TARGET))

clooproot: host-cloop host-cdrkit host-fakeroot
	rm -f $(CLOOP_FAKEROOT_SCRIPT)
	touch $(BUILD_DIR)/.fakeroot.00000
	cat $(BUILD_DIR)/.fakeroot* > $(CLOOP_FAKEROOT_SCRIPT)
	# Use fakeroot to pretend all target binaries are owned by root
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(CLOOP_FAKEROOT_SCRIPT)
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(HOST_DIR)/usr/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(CLOOP_FAKEROOT_SCRIPT)
endif
	# Use fakeroot so genisoimage believes the previous fakery
	echo "$(HOST_DIR)/usr/bin/genisoimage -r $(TARGET_DIR) | $(HOST_DIR)/usr/bin/create_compressed_fs - 65536 > $(CLOOP_TARGET)" >> $(CLOOP_FAKEROOT_SCRIPT)
	chmod a+x $(CLOOP_FAKEROOT_SCRIPT)
	$(HOST_DIR)/usr/bin/fakeroot -- $(CLOOP_FAKEROOT_SCRIPT)
	-@rm -f $(CLOOP_FAKEROOT_SCRIPT)

ifeq ($(BR2_TARGET_ROOTFS_CLOOP),y)
TARGETS+=clooproot
endif
