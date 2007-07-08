#############################################################
#
# Make a initramfs_list file to be used by gen_init_cpio
# gen_init_cpio is part of the 2.6 linux kernels to build an 
# initial ramdisk filesystem based on cpio
#
#############################################################

ifeq ($(strip $(BR2_TARGET_ROOTFS_INITRAMFS)),y)
INITRAMFS_TARGET:=$(IMAGE).initramfs_list
else
INITRAMFS_TARGET:= #nothing
endif

$(INITRAMFS_TARGET) initramfs: host-fakeroot makedevs
	-find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIP) 2>/dev/null || true;
	rm -rf $(TARGET_DIR)/usr/man
	rm -rf $(TARGET_DIR)/usr/info
	-/sbin/ldconfig -r $(TARGET_DIR) 2>/dev/null
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	touch $(STAGING_DIR)/.fakeroot.00000
	cat $(STAGING_DIR)/.fakeroot* > $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(STAGING_DIR)/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	# Use fakeroot so gen_initramfs_list.sh  believes the previous fakery
	echo "$(CONFIG_SHELL) target/initramfs/gen_initramfs_list.sh -u 0 -g 0 $(TARGET_DIR) > $(INITRAMFS_TARGET)" \
		>> $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	chmod a+x $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	$(STAGING_DIR)/usr/bin/fakeroot -- $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	-rm -f $(STAGING_DIR)/_fakeroot.$(notdir $(TAR_TARGET))

initramfs-source:

initramfs-clean:
ifeq ($(strip $(BR2_TARGET_ROOTFS_INITRAMFS)),y)
	-rm -f $(INITRAMFS_TARGET)
endif
initramfs-dirclean:


