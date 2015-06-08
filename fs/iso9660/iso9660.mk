################################################################################
#
# Build the iso96600 root filesystem image
#
################################################################################

ISO9660_TARGET_DIR = $(BUILD_DIR)/rootfs-iso9660.tmp
ISO9660_BOOT_MENU := $(call qstrip,$(BR2_TARGET_ROOTFS_ISO9660_BOOT_MENU))

ROOTFS_ISO9660_DEPENDENCIES = grub host-cdrkit host-fakeroot linux rootfs-cpio

ifeq ($(BR2_TARGET_GRUB_SPLASH),y)
define ROOTFS_ISO9660_SPLASHSCREEN
	$(INSTALL) -D -m 0644 boot/grub/splash.xpm.gz \
		$(ISO9660_TARGET_DIR)/splash.xpm.gz
endef
else
define ROOTFS_ISO9660_SPLASHSCREEN
	$(SED) '/^splashimage/d' $(ISO9660_TARGET_DIR)/boot/grub/menu.lst
endef
endif

ifeq ($(BR2_TARGET_ROOTFS_INITRAMFS),y)
define ROOTFS_ISO9660_INITRD
	$(SED) '/initrd/d'  $(ISO9660_TARGET_DIR)/boot/grub/menu.lst
endef
else
define ROOTFS_ISO9660_INITRD
	$(INSTALL) -D -m 0644 $(BINARIES_DIR)/rootfs.cpio$(ROOTFS_CPIO_COMPRESS_EXT) \
		$(ISO9660_TARGET_DIR)/initrd
endef
endif

define ROOTFS_ISO9660_PREPARATION
	$(RM) -rf $(ISO9660_TARGET_DIR)
	mkdir -p $(ISO9660_TARGET_DIR)
	$(INSTALL) -D -m 0644 $(GRUB_DIR)/stage2/stage2_eltorito \
		$(ISO9660_TARGET_DIR)/boot/grub/stage2_eltorito
	$(INSTALL) -D -m 0644 $(ISO9660_BOOT_MENU) \
		$(ISO9660_TARGET_DIR)/boot/grub/menu.lst
	$(INSTALL) -D -m 0644 $(LINUX_IMAGE_PATH) $(ISO9660_TARGET_DIR)/kernel
	$(ROOTFS_ISO9660_SPLASHSCREEN)
	$(ROOTFS_ISO9660_INITRD)
endef

ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_PREPARATION

define ROOTFS_ISO9660_CMD
	$(HOST_DIR)/usr/bin/genisoimage -R -b boot/grub/stage2_eltorito \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		-o $@ $(ISO9660_TARGET_DIR)
endef

$(eval $(call ROOTFS_TARGET,iso9660))
