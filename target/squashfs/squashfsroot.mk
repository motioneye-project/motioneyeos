#############################################################
#
# mksquashfs to build to target squashfs filesystems
#
#############################################################
SQUASHFS_DIR=$(BUILD_DIR)/squashfs1.3r3
SQUASHFS_SOURCE=squashfs1.3r3.tar.gz
SQUASHFS_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/squashfs

$(DL_DIR)/$(SQUASHFS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(SQUASHFS_SITE)/$(SQUASHFS_SOURCE)

$(SQUASHFS_DIR)/.unpacked: $(DL_DIR)/$(SQUASHFS_SOURCE) #$(SQUASHFS_PATCH)
	zcat $(DL_DIR)/$(SQUASHFS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(SQUASHFS_DIR) target/squashfs/ squashfs.patch
	touch $(SQUASHFS_DIR)/.unpacked

$(SQUASHFS_DIR)/squashfs-tools/mksquashfs: $(SQUASHFS_DIR)/.unpacked
	$(MAKE) -C $(SQUASHFS_DIR)/squashfs-tools;

squashfs: $(SQUASHFS_DIR)/squashfs-tools/mksquashfs

squashfs-source: $(DL_DIR)/$(SQUASHFS_SOURCE)

squashfs-clean:
	-$(MAKE) -C $(SQUASHFS_DIR)/squashfs-tools clean

squashfs-dirclean:
	rm -rf $(SQUASHFS_DIR)

#############################################################
#
# Build the squashfs root filesystem image
#
#############################################################

squashfsroot: squashfs host-fakeroot makedevs
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
		-r $(TARGET_DIR) \
		-d target/generic/device_table.txt
	# Use fakeroot to fake out mksquashfs per the previous fakery
	$(STAGING_DIR)/usr/bin/fakeroot \
		-i $(STAGING_DIR)/fakeroot.env \
		-s $(STAGING_DIR)/fakeroot.env -- \
		$(SQUASHFS_DIR)/squashfs-tools/mksquashfs $(TARGET_DIR) \
		$(IMAGE).squashfs -noappend

squashfsroot-source: squashfs-source

squashfsroot-clean:
	-$(MAKE) -C $(SQUASHFS_DIR) clean

squashfsroot-dirclean:
	rm -rf $(SQUASHFS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_TARGET_ROOTFS_SQUASHFS)),y)
TARGETS+=squashfsroot
endif
