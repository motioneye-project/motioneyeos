#############################################################
#
# busybox image for initramfs
#
#############################################################

BUSYBOX_INITRAMFS_DIR:=$(BUSYBOX_DIR)-initramfs

$(BUSYBOX_INITRAMFS_DIR)/.unpacked: $(DL_DIR)/$(BUSYBOX_SOURCE)
	rm -rf $(BUILD_DIR)/tmp $(BUSYBOX_INITRAMFS_DIR)
	-mkdir $(BUILD_DIR)/tmp
	$(BUSYBOX_UNZIP) $(DL_DIR)/$(BUSYBOX_SOURCE) | tar -C $(BUILD_DIR)/tmp $(TAR_OPTIONS) -
ifeq ($(strip $(BR2_PACKAGE_BUSYBOX_SNAPSHOT)),y)
	mv $(BUILD_DIR)/tmp/busybox $(BUSYBOX_INITRAMFS_DIR)
else
	mv $(BUILD_DIR)/tmp/busybox-$(BUSYBOX_VERSION) $(BUSYBOX_INITRAMFS_DIR)
endif
	touch $@

$(BUSYBOX_INITRAMFS_DIR)/.configured: $(BUSYBOX_INITRAMFS_DIR)/.unpacked
	(echo CONFIG_CAT=y; \
	 echo CONFIG_CHROOT=y; \
	 echo CONFIG_DD=y; \
	 echo CONFIG_FEATURE_DD_IBS_OBS=y; \
	 echo CONFIG_FALSE=y; \
	 echo CONFIG_GUNZIP=y; \
	 echo CONFIG_HALT=y; \
	 echo CONFIG_INSMOD=y; \
	 echo CONFIG_KILL=y; \
	 echo CONFIG_LN=y; \
	 echo CONFIG_PS=y; \
	 echo CONFIG_MDEV=y; \
	 echo CONFIG_MKDIR=y; \
	 echo CONFIG_MKFIFO=y; \
	 echo CONFIG_MKNOD=y; \
	 echo CONFIG_MODPROBE=y; \
	 echo CONFIG_FEATURE_MODPROBE_MULTIPLE_OPTIONS=y; \
	 echo CONFIG_FEATURE_MODPROBE_FANCY_ALIAS=y; \
	 echo CONFIG_FEATURE_CHECK_TAINTED_MODULE=n; \
	 echo CONFIG_FEATURE_2_4_MODULES=n; \
	 echo CONFIG_MOUNT=y; \
	 echo CONFIG_SWITCH_ROOT=y; \
	 echo CONFIG_READLINK=y; \
	 echo CONFIG_RMMOD=y; \
	 echo CONFIG_MSH=y; \
	 echo CONFIG_FEATURE_SH_IS_MSH=y; \
	 echo CONFIG_SLEEP=y; \
	 echo CONFIG_STATIC=y; \
	 echo CONFIG_TRUE=y; \
	 echo CONFIG_UMOUNT=y; \
	 echo CONFIG_FEATURE_UMOUNT_ALL=y; \
	 echo CONFIG_UNAME=y; \
	) > $(BUSYBOX_INITRAMFS_DIR)/.config 
	yes "" | $(MAKE) CC=$(TARGET_CC) CROSS_COMPILE="$(TARGET_CROSS)" \
		CROSS="$(TARGET_CROSS)" -C $(BUSYBOX_INITRAMFS_DIR) oldconfig
	touch $@


$(BUSYBOX_INITRAMFS_DIR)/inst/busybox: $(BUSYBOX_INITRAMFS_DIR)/.configured
	-mkdir $(@D)
	$(MAKE) CC=$(TARGET_CC) CROSS_COMPILE="$(TARGET_CROSS)" \
		CROSS="$(TARGET_CROSS)" PREFIX="$(TARGET_DIR)" \
		ARCH=$(KERNEL_ARCH) \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" -C $(BUSYBOX_INITRAMFS_DIR) \
		busybox.links busybox
ifeq ($(BR2_PREFER_IMA)$(BR2_PACKAGE_BUSYBOX_SNAPSHOT),yy)
	rm -f $@
	$(MAKE) CC=$(TARGET_CC) CROSS_COMPILE="$(TARGET_CROSS)" \
		CROSS="$(TARGET_CROSS)" PREFIX="$(TARGET_DIR)" \
		ARCH=$(KERNEL_ARCH) STRIP="$(STRIP)" \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" -C $(BUSYBOX_INITRAMFS_DIR) \
		-f scripts/Makefile.IMA
endif
	cp -f $(BUSYBOX_INITRAMFS_DIR)/busybox $@
	$(STRIP) $(STRIP_STRIP_ALL) $@

busybox-initramfs: uclibc $(BUSYBOX_INITRAMFS_DIR)/inst/busybox

busybox-initramfs-menuconfig: host-sed $(BUILD_DIR) busybox-source $(BUSYBOX_INITRAMFS_DIR)/.configured
	$(MAKE) __TARGET_ARCH=$(ARCH) -C $(BUSYBOX_INITRAMFS_DIR) menuconfig

busybox-initramfs-clean:
	rm -f $(BUSYBOX_INITRAMFS_DIR)/busybox \
		$(BUSYBOX_INITRAMFS_DIR)/inst/busybox
	-$(MAKE) -C $(BUSYBOX_INITRAMFS_DIR) clean

busybox-initramfs-dirclean:
	rm -rf $(BUSYBOX_INITRAMFS_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_BUSYBOX_INITRAMFS)),y)
TARGETS+=busybox-initramfs
endif
