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
	rm -f $(TARGET_DIR)/init
	ln -s sbin/init $(TARGET_DIR)/init
	-find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIP) 2>/dev/null || true
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(TARGET_DIR)/usr/man
endif
ifneq ($(BR2_HAVE_INFOPAGES),y)
	rm -rf $(TARGET_DIR)/usr/info
endif
	$(if $(TARGET_LDCONFIG),test -x $(TARGET_LDCONFIG) && $(TARGET_LDCONFIG) -r $(TARGET_DIR) 2>/dev/null)
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	touch $(PROJECT_BUILD_DIR)/.fakeroot.00000
	cat $(PROJECT_BUILD_DIR)/.fakeroot* > $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(STAGING_DIR)/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	# Use fakeroot so gen_initramfs_list.sh believes the previous fakery
	echo "$(CONFIG_SHELL) target/initramfs/gen_initramfs_list.sh -u 0 -g 0 $(TARGET_DIR) > $(INITRAMFS_TARGET)" \
		>> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	chmod a+x $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	$(STAGING_DIR)/usr/bin/fakeroot -- $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	-rm -f $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(TAR_TARGET))

initramfs-source:

initramfs-clean:
ifeq ($(strip $(BR2_TARGET_ROOTFS_INITRAMFS)),y)
	-rm -f $(INITRAMFS_TARGET)
endif
initramfs-dirclean:


