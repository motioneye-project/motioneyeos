#############################################################
#
# cpio to archive target filesystem
#
#############################################################

CPIO_TARGET:=$(IMAGE).cpio

cpioroot-init:
	rm -f $(TARGET_DIR)/init
	ln -s sbin/init $(TARGET_DIR)/init

cpioroot: host-fakeroot makedevs cpioroot-init
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIP) 2>/dev/null || true;
	@rm -rf $(TARGET_DIR)/usr/man
	@rm -rf $(TARGET_DIR)/usr/info
	-/sbin/ldconfig -r $(TARGET_DIR) 2>/dev/null
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	touch $(STAGING_DIR)/.fakeroot.00000
	cat $(STAGING_DIR)/.fakeroot* > $(STAGING_DIR)/_fakeroot.$(notdir $(CPIO_TARGET))
	echo "chown -R root:root $(TARGET_DIR)" >> $(STAGING_DIR)/_fakeroot.$(notdir $(CPIO_TARGET))
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(STAGING_DIR)/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(STAGING_DIR)/_fakeroot.$(notdir $(CPIO_TARGET))
	# Use fakeroot so tar believes the previous fakery
	echo "cd $(TARGET_DIR) && find . | cpio --quiet -o -H newc > $(CPIO_TARGET)" \
		>> $(STAGING_DIR)/_fakeroot.$(notdir $(CPIO_TARGET))
	chmod a+x $(STAGING_DIR)/_fakeroot.$(notdir $(CPIO_TARGET))
	$(STAGING_DIR)/usr/bin/fakeroot -- $(STAGING_DIR)/_fakeroot.$(notdir $(CPIO_TARGET))
	#-@rm -f $(STAGING_DIR)/_fakeroot.$(notdir $(CPIO_TARGET))

cpioroot-source:

cpioroot-clean:

cpioroot-dirclean:

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_TARGET_ROOTFS_CPIO)),y)
TARGETS+=cpioroot
endif
