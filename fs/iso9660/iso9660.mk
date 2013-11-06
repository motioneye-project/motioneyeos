################################################################################
#
# Build the iso96600 root filesystem image
#
# Cannot be converted to the ROOTFS_TARGET infrastructure, because of
# the temporary construction in ISO9660_TARGET_DIR.
#
################################################################################

ISO9660_TARGET_DIR = $(BUILD_DIR)/iso9660
ISO9660_BOOT_MENU := $(call qstrip,$(BR2_TARGET_ROOTFS_ISO9660_BOOT_MENU))

$(BINARIES_DIR)/rootfs.iso9660: host-cdrkit host-fakeroot linux rootfs-cpio grub
	@$(call MESSAGE,"Generating root filesystem image rootfs.iso9660")
	mkdir -p $(ISO9660_TARGET_DIR)
	mkdir -p $(ISO9660_TARGET_DIR)/boot/grub
	cp $(GRUB_DIR)/stage2/stage2_eltorito $(ISO9660_TARGET_DIR)/boot/grub/
	cp $(ISO9660_BOOT_MENU) $(ISO9660_TARGET_DIR)/boot/grub/menu.lst
	cp $(LINUX_IMAGE_PATH) $(ISO9660_TARGET_DIR)/kernel
	cp $(BINARIES_DIR)/rootfs.cpio$(ROOTFS_CPIO_COMPRESS_EXT) $(ISO9660_TARGET_DIR)/initrd
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(FAKEROOT_SCRIPT)
	echo "chown -R 0:0 $(ISO9660_TARGET_DIR)" >> $(FAKEROOT_SCRIPT)
	# Use fakeroot so mkisofs believes the previous fakery
	echo "$(HOST_DIR)/usr/bin/genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot " \
		"-boot-load-size 4 -boot-info-table -o $@ $(ISO9660_TARGET_DIR)" \
		>> $(FAKEROOT_SCRIPT)
	chmod a+x $(FAKEROOT_SCRIPT)
	$(HOST_DIR)/usr/bin/fakeroot -- $(FAKEROOT_SCRIPT)
	-@rm -f $(FAKEROOT_SCRIPT)
	-@rm -rf $(ISO9660_TARGET_DIR)

rootfs-iso9660: $(BINARIES_DIR)/rootfs.iso9660

################################################################################
#
# Toplevel Makefile options
#
################################################################################
ifeq ($(BR2_TARGET_ROOTFS_ISO9660),y)
TARGETS+=rootfs-iso9660
endif
