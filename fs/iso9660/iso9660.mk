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

ROOTFS_ISO9660_DEPENDENCIES = grub host-cdrkit host-fakeroot linux rootfs-cpio

$(BINARIES_DIR)/rootfs.iso9660: $(ROOTFS_ISO9660_DEPENDENCIES)
	@$(call MESSAGE,"Generating root filesystem image rootfs.iso9660")
	$(INSTALL) -D -m 0644 $(GRUB_DIR)/stage2/stage2_eltorito \
		$(ISO9660_TARGET_DIR)/boot/grub/stage2_eltorito
	$(INSTALL) -D -m 0644 $(ISO9660_BOOT_MENU) \
		$(ISO9660_TARGET_DIR)/boot/grub/menu.lst
ifeq ($(BR2_TARGET_GRUB_SPLASH),)
	$(SED) '/^splashimage/d' $(ISO9660_TARGET_DIR)/boot/grub/menu.lst
else
	$(INSTALL) -D -m 0644 boot/grub/splash.xpm.gz \
		$(ISO9660_TARGET_DIR)/splash.xpm.gz
endif
	$(INSTALL) -D -m 0644 $(LINUX_IMAGE_PATH) $(ISO9660_TARGET_DIR)/kernel
ifeq ($(BR2_TARGET_ROOTFS_INITRAMFS),y)
	$(SED) '/initrd/d'  $(ISO9660_TARGET_DIR)/boot/grub/menu.lst
else
	$(INSTALL) -D -m 0644 $(BINARIES_DIR)/rootfs.cpio$(ROOTFS_CPIO_COMPRESS_EXT) \
		$(ISO9660_TARGET_DIR)/initrd
endif
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(FAKEROOT_SCRIPT)
	echo "chown -h -R 0:0 $(ISO9660_TARGET_DIR)" >> $(FAKEROOT_SCRIPT)
	# Use fakeroot so mkisofs believes the previous fakery
	echo "$(HOST_DIR)/usr/bin/genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot " \
		"-boot-load-size 4 -boot-info-table -o $@ $(ISO9660_TARGET_DIR)" \
		>> $(FAKEROOT_SCRIPT)
	chmod a+x $(FAKEROOT_SCRIPT)
	$(HOST_DIR)/usr/bin/fakeroot -- $(FAKEROOT_SCRIPT)
	-@rm -f $(FAKEROOT_SCRIPT)
	-@rm -rf $(ISO9660_TARGET_DIR)

rootfs-iso9660: $(BINARIES_DIR)/rootfs.iso9660

rootfs-iso9660-show-depends:
	@echo $(ROOTFS_ISO9660_DEPENDENCIES)

################################################################################
#
# Toplevel Makefile options
#
################################################################################
ifeq ($(BR2_TARGET_ROOTFS_ISO9660),y)
TARGETS_ROOTFS += rootfs-iso9660
endif
