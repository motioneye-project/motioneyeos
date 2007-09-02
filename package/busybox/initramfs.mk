#############################################################
#
# busybox image for initramfs
#
#############################################################

BUSYBOX_INITRAMFS_DIR:=$(BUSYBOX_DIR)-initramfs
BR2_INITRAMFS_DIR:=$(PROJECT_BUILD_DIR)/initramfs

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

$(BUSYBOX_INITRAMFS_DIR)/.config $(BUSYBOX_INITRAMFS_DIR)/.configured: $(BUSYBOX_INITRAMFS_DIR)/.unpacked
	$(MAKE) CC=$(TARGET_CC) CROSS_COMPILE="$(TARGET_CROSS)" \
                CROSS="$(TARGET_CROSS)" -C $(BUSYBOX_INITRAMFS_DIR) \
		allnoconfig
	mv $(BUSYBOX_INITRAMFS_DIR)/.config $(BUSYBOX_INITRAMFS_DIR)/.config.no
	(echo CONFIG_PREFIX=\"$(BR2_INITRAMFS_DIR)\"; \
	 echo CONFIG_NITPICK=y; \
	 echo CONFIG_FEATURE_BUFFERS_USE_MALLOC=y; \
	 echo CONFIG_INCLUDE_SUSv2=n; \
	 echo CONFIG_CAT=y; \
	 echo CONFIG_CHROOT=y; \
	 echo CONFIG_DD=y; \
	 echo CONFIG_FEATURE_DD_IBS_OBS=y; \
	 echo CONFIG_FALSE=y; \
	 echo CONFIG_GUNZIP=y; \
	 echo CONFIG_HALT=y; \
	 echo CONFIG_INSMOD=y; \
	 echo CONFIG_KILL=y; \
	 echo CONFIG_LN=y; \
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
	 echo CONFIG_MSH=y; \
	 echo CONFIG_FEATURE_SH_IS_MSH=y; \
	 echo CONFIG_PS=y; \
	 echo CONFIG_READLINK=y; \
	 echo CONFIG_RMMOD=y; \
	 echo CONFIG_SLEEP=y; \
	 echo CONFIG_STATIC=y; \
	 echo CONFIG_SWITCH_ROOT=y; \
	 echo CONFIG_TRUE=y; \
	 echo CONFIG_UMOUNT=y; \
	 echo CONFIG_FEATURE_UMOUNT_ALL=y; \
	 echo CONFIG_UNAME=y; \
	) > $(BUSYBOX_INITRAMFS_DIR)/.config
	cp -f $(BUSYBOX_INITRAMFS_DIR)/.config \
		$(BUSYBOX_INITRAMFS_DIR)/.config.prune
	$(SED) 's|\([^=]*\)=.*|/\1[^_]*/d|g' \
		$(BUSYBOX_INITRAMFS_DIR)/.config.prune
	$(SED) '' -f $(BUSYBOX_INITRAMFS_DIR)/.config.prune \
		$(BUSYBOX_INITRAMFS_DIR)/.config.no
	cat $(BUSYBOX_INITRAMFS_DIR)/.config.no >> \
		$(BUSYBOX_INITRAMFS_DIR)/.config
	yes "" | $(MAKE) CC=$(TARGET_CC) CROSS_COMPILE="$(TARGET_CROSS)" \
		CROSS="$(TARGET_CROSS)" -C $(BUSYBOX_INITRAMFS_DIR) \
		oldconfig
	touch $@


$(BUSYBOX_INITRAMFS_DIR)/busybox: $(BUSYBOX_INITRAMFS_DIR)/.configured
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

$(BR2_INITRAMFS_DIR)/bin/busybox: $(BUSYBOX_INITRAMFS_DIR)/busybox
	$(MAKE) CC=$(TARGET_CC) CROSS_COMPILE="$(TARGET_CROSS)" \
		CROSS="$(TARGET_CROSS)" \
		ARCH=$(KERNEL_ARCH) STRIP="$(STRIP)" \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" -C $(BUSYBOX_INITRAMFS_DIR) \
		install
	$(STRIP) $(STRIP_STRIP_ALL) $@

$(PROJECT_BUILD_DIR)/.initramfs_done: $(BR2_INITRAMFS_DIR)/bin/busybox
	touch $@

busybox-initramfs: uclibc $(PROJECT_BUILD_DIR)/.initramfs_done

busybox-initramfs-menuconfig: host-sed $(BUILD_DIR) busybox-source $(BUSYBOX_INITRAMFS_DIR)/.configured
	$(MAKE) __TARGET_ARCH=$(ARCH) -C $(BUSYBOX_INITRAMFS_DIR) menuconfig

busybox-initramfs-clean:
	rm -f $(BUSYBOX_INITRAMFS_DIR)/busybox $(PROJECT_BUILD_DIR)/.initramfs_*
	rm -rf $(BR2_INITRAMFS_DIR)
	-$(MAKE) -C $(BUSYBOX_INITRAMFS_DIR) clean

busybox-initramfs-dirclean:
	rm -rf $(BUSYBOX_INITRAMFS_DIR) $(BR2_INITRAMFS_DIR) \
		$(PROJECT_BUILD_DIR)/.initramfs_*
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_BUSYBOX_INITRAMFS)),y)
TARGETS+=busybox-initramfs
endif
