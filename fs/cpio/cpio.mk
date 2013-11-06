################################################################################
#
# cpio to archive target filesystem
#
################################################################################

ifeq ($(BR2_ROOTFS_DEVICE_CREATION_STATIC),y)

define ROOTFS_CPIO_ADD_INIT
        if [ ! -e $(TARGET_DIR)/init ]; then \
                ln -sf sbin/init $(TARGET_DIR)/init; \
        fi
endef

else
# devtmpfs does not get automounted when initramfs is used.
# Add a pre-init script to mount it before running init
define ROOTFS_CPIO_ADD_INIT
        if [ ! -e $(TARGET_DIR)/init ]; then \
                $(INSTALL) -m 0755 fs/cpio/init $(TARGET_DIR)/init; \
        fi
endef

PACKAGES_PERMISSIONS_TABLE += /dev/console c 622 0 0 5 1 - - -$(sep)

endif # BR2_ROOTFS_DEVICE_CREATION_STATIC

ROOTFS_CPIO_PRE_GEN_HOOKS += ROOTFS_CPIO_ADD_INIT

define ROOTFS_CPIO_CMD
	cd $(TARGET_DIR) && find . | cpio --quiet -o -H newc > $@
endef

# mkimage supports arm avr32 blackfin m68k microblaze mips mips64 nios2 powerpc ppc sh sparc sparc64 x86
# KERNEL_ARCH can be arm64 arc arm avr32 blackfin m68k microblaze mips nios2 powerpc sh sparc i386 x86_64 xtensa
# For arm64, arc, xtensa we'll just keep KERNEL_ARCH
# For mips64, we'll just keep mips
# For i386 and x86_64, we need to convert
ifeq ($(KERNEL_ARCH),x86_64)
UIMAGE_ARCH = x86
else ifeq ($(KERNEL_ARCH),i386)
UIMAGE_ARCH = x86
else
UIMAGE_ARCH = $(KERNEL_ARCH)
endif

$(BINARIES_DIR)/rootfs.cpio.uboot: $(BINARIES_DIR)/rootfs.cpio host-uboot-tools
	$(HOST_DIR)/usr/bin/mkimage -A $(UIMAGE_ARCH) -T ramdisk \
		-C none -d $<$(ROOTFS_CPIO_COMPRESS_EXT) $@

ifeq ($(BR2_TARGET_ROOTFS_CPIO_UIMAGE),y)
ROOTFS_CPIO_POST_TARGETS += $(BINARIES_DIR)/rootfs.cpio.uboot
endif

$(eval $(call ROOTFS_TARGET,cpio))
