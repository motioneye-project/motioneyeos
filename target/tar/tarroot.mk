#############################################################
#
# tar to archive target filesystem
#
#############################################################

TAR_OPTS := $(strip $(BR2_TARGET_ROOTFS_TAR_OPTIONS))

tarroot: host-fakeroot makedevs
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIP) 2>/dev/null || true;
	@rm -rf $(TARGET_DIR)/usr/man
	@rm -rf $(TARGET_DIR)/usr/info
	# Use fakeroot to munge permissions and do root-like things
	rm -f $(STAGING_DIR)/fakeroot.env
	touch $(STAGING_DIR)/fakeroot.env
	# Use fakeroot to pretend all target binaries are owned by root
	$(STAGING_DIR)/usr/bin/fakeroot \
		-i $(STAGING_DIR)/fakeroot.env \
		-s $(STAGING_DIR)/fakeroot.env -- \
		chown -R root:root $(TARGET_DIR)
	# Use fakeroot to pretend to create all needed device nodes
	$(STAGING_DIR)/usr/bin/fakeroot \
		-i $(STAGING_DIR)/fakeroot.env \
		-s $(STAGING_DIR)/fakeroot.env -- \
		$(STAGING_DIR)/bin/makedevs \
		-d target/generic/device_table.txt \
		$(TARGET_DIR)
	# Use fakeroot to fake out tar per the previous fakery
	$(STAGING_DIR)/usr/bin/fakeroot \
		-i $(STAGING_DIR)/fakeroot.env \
		-s $(STAGING_DIR)/fakeroot.env -- \
		tar -c$(TAR_OPTS)f $(IMAGE).tar -C $(TARGET_DIR) .

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
