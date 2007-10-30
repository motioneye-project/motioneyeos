PROJECT_FILE:=$(LOCAL)/$(PROJECT)/$(PROJECT).config


.PHONY: target-host-info saveconfig getconfig

target-host-info: $(TARGET_DIR)/etc/issue $(TARGET_DIR)/etc/hostname

$(TARGET_DIR)/etc/issue: .config
	mkdir -p $(TARGET_DIR)/etc
	echo "" > $(TARGET_DIR)/etc/issue
	echo "" >> $(TARGET_DIR)/etc/issue
	echo "$(BANNER)" >> $(TARGET_DIR)/etc/issue

$(TARGET_DIR)/etc/hostname: .config
	mkdir -p $(TARGET_DIR)/etc
	echo "$(TARGET_HOSTNAME)" > $(TARGET_DIR)/etc/hostname

saveconfig: $(CONFIG)/conf
	mkdir -p $(LOCAL)/$(PROJECT)
	-cp .config $(PROJECT_FILE)
	if [ -f $(LINUX26_DIR)/.config ]; then \
		cp $(LINUX26_DIR)/.config \
			$(LOCAL)/$(PROJECT)/linux-$(LINUX26_VERSION).config; \
		$(SED) '/BR2_PACKAGE_LINUX_KCONFIG/d' $(PROJECT_FILE); \
		echo "BR2_PACKAGE_LINUX_KCONFIG=\"$(LOCAL)/$(PROJECT)/linux-$(LINUX26_VERSION).config\"" >> $(PROJECT_FILE); \
	fi
	if [ -f $(BUSYBOX_DIR)/.config ]; then \
		cp $(BUSYBOX_DIR)/.config \
			$(LOCAL)/$(PROJECT)/busybox-$(BUSYBOX_VERSION).config; \
		$(SED) '/BR2_PACKAGE_BUSYBOX_CONFIG/d' $(PROJECT_FILE); \
		echo "BR2_PACKAGE_BUSYBOX_CONFIG=\"$(LOCAL)/$(PROJECT)/busybox-$(BUSYBOX_VERSION).config\"" >> $(PROJECT_FILE); \
	fi
	if [ -f $(UCLIBC_DIR)/.config ]; then \
		cp $(UCLIBC_DIR)/.config \
			$(LOCAL)/$(PROJECT)/uclibc-$(UCLIBC_VER).config; \
		$(SED) '/BR2_UCLIBC_CONFIG/d' $(PROJECT_FILE); \
		echo "BR2_UCLIBC_CONFIG=\"$(LOCAL)/$(PROJECT)/uclibc-$(UCLIBC_VER).config\"" >> $(PROJECT_FILE); \
	fi
	if [ -f $(UBOOT_DIR)/include/configs/$(PROJECT).h ]; then \
		mkdir -p $(LOCAL)/$(PROJECT)/u-boot; \
		cp $(UBOOT_DIR)/include/configs/$(PROJECT).h \
			$(LOCAL)/$(PROJECT)/u-boot/$(PROJECT).h; \
	fi

getconfig: $(CONFIG)/conf
	-cp $(LOCAL)/$(PROJECT)/$(PROJECT).config .config

vendor-dbg:
	@echo VENDOR_SITE=$(BR2_VENDOR_SITE)
	@echo VENDOR_SUFFIX=$(BR2_VENDOR_SUFFIX)
	@echo VENDOR_BINUTILS_RELEASE=$(BR2_VENDOR_BINUTILS_RELEASE)
	@echo VENDOR_GCC_RELEASE=$(BR2_VENDOR_GCC_RELEASE)
	@echo VENDOR_UCLIBC_RELEASE=$(BR2_VENDOR_UCLIBC_RELEASE)
	@echo VENDOR_GDB_RELEASE=$(BR2_VENDOR_GDB_RELEASE)
	@echo VENDOR_PATCH_DIR=$(BR2_VENDOR_PATCH_DIR)
