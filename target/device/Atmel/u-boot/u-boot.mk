#############################################################
#
# u-boot mkimage to build to target u-boot filesystems and
#
# u-boot.bin - the boot loader for the target - which needs soft float, so
# we won't make it.
#
#
#############################################################
UBOOT_VERSION:=1.2.0-atmel
ATMEL_MIRROR:=$(strip $(subst ",, $(BR2_ATMEL_MIRROR)))
#"))
UBOOT_DIR:=$(BUILD_DIR)/u-boot-$(UBOOT_VERSION)
UBOOT_BUILD_DIR:=$(PROJECT_BUILD_DIR)/u-boot-$(UBOOT_VERSION)
UBOOT_SOURCE:=u-boot-$(UBOOT_VERSION).tar.bz2
#UBOOT_SOURCE:=u-boot-1.1.5-atmel.tar.bz2
#UBOOT_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/u-boot
UBOOT_SITE:=$(ATMEL_MIRROR)
UBOOT_PATCH_SITE:=$(ATMEL_MIRROR)
UBOOT_CAT:=$(BZCAT)
UBOOT_PATCH_SOURCE:=u-boot-1.2.0-atmel-patch.tar.bz2

MKIMAGE_BINLOC:=$(UBOOT_BUILD_DIR)/tools/mkimage
MKIMAGE:=$(KERNEL_CROSS)mkimage

UBOOT_BIN:=$(BOARD_NAME)-u-boot-$(UBOOT_VERSION)-$(DATE).bin

UBOOT_PATCHES:=$(PROJECT_BUILD_DIR)/u-boot-patches

UBOOT_ATMEL_BMP:=$(UBOOT_PATCHES)/atmel.bmp

UBOOT_SCR=$(BINARIES_DIR)/autoscript
TARGET_UBOOT_IPADDR:=$(strip $(subst ",, $(BR2_TARGET_UBOOT_IPADDR_AT91)))
#"))
TARGET_UBOOT_SERVERIP:=$(strip $(subst ",, $(BR2_TARGET_UBOOT_SERVERIP_AT91)))
#"))
TARGET_UBOOT_GATEWAY:=$(strip $(subst ",, $(BR2_TARGET_UBOOT_GATEWAY_AT91)))
#"))
TARGET_UBOOT_NETMASK:=$(strip $(subst ",, $(BR2_TARGET_UBOOT_NETMASK_AT91)))
#"))
TARGET_UBOOT_ETHADDR:=$(strip $(subst ",, $(BR2_TARGET_UBOOT_ETHADDR_AT91)))
#"))
UBOOT_CUSTOM:=$(UBOOT_DIR)/include/custom.h

$(DL_DIR)/$(UBOOT_SOURCE):
	$(WGET) -P $(DL_DIR) $(UBOOT_SITE)/$(UBOOT_SOURCE)

$(DL_DIR)/$(UBOOT_PATCH_SOURCE):
	$(WGET) -P $(DL_DIR) $(UBOOT_PATCH_SITE)/$(UBOOT_PATCH_SOURCE)

$(UBOOT_DIR)/.unpacked: $(DL_DIR)/$(UBOOT_SOURCE)
	mkdir -p $(BUILD_DIR)
	$(UBOOT_CAT) $(DL_DIR)/$(UBOOT_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $@

$(UBOOT_PATCHES)/.unpacked: $(DL_DIR)/$(UBOOT_PATCH_SOURCE)
	mkdir -p $(UBOOT_PATCHES)
	bzcat $(DL_DIR)/$(UBOOT_PATCH_SOURCE) | tar -C $(UBOOT_PATCHES) -xvf -
	touch $@

$(UBOOT_DIR)/.patched.$(UBOOT_PATCH_SOURCE): $(UBOOT_DIR)/.unpacked $(UBOOT_PATCHES)/.unpacked
	toolchain/patch-kernel.sh $(UBOOT_DIR) $(UBOOT_PATCHES) \*.patch
	touch $(UBOOT_DIR)/.patched.$(UBOOT_PATCH_SOURCE)
# cp $(UBOOT_CONFIG_FILE) $(UBOOT_DIR)/include/configs/.
# cp $(UBOOT_PATCHES)/cmd_defenv.c $(UBOOT_DIR)/common/.
# cp $(UBOOT_ATMEL_BMP) $(UBOOT_DIR)/tools/logos/.

$(UBOOT_BUILD_DIR)/.configured: $(UBOOT_DIR)/.patched.$(UBOOT_PATCH_SOURCE)
ifneq ($(strip $(UBOOT_CONFIG_FILE)),)
	cp $(UBOOT_CONFIG_FILE) $(UBOOT_DIR)/include/configs/.
endif
	$(MAKE) \
		O=$(UBOOT_BUILD_DIR) \
		CONFIG_NOSOFTFLOAT=1 \
		-C $(UBOOT_DIR) \
		$(UBOOT_CONFIG)
	$(SED) 's/ $$(SREC) $$(BIN)//' $(UBOOT_DIR)/examples/Makefile
	touch $(UBOOT_BUILD_DIR)/.configured
# $(MAKE) O=$(UBOOT_BUILD_DIR) -C $(UBOOT_DIR)

$(MKIMAGE_BINLOC): $(UBOOT_BUILD_DIR)/.configured
	$(MAKE) \
		O=$(UBOOT_BUILD_DIR) \
		CROSS_COMPILE= \
		CONFIG_NOSOFTFLOAT=1 \
		TOPDIR=$(UBOOT_DIR) \
		SRCTREE=$(UBOOT_DIR) \
		-C $(UBOOT_DIR) tools
	touch $(MKIMAGE_BINLOC)

$(UBOOT_BUILD_DIR)/u-boot.bin: $(UBOOT_BUILD_DIR)/.configured $(UBOOT_CUSTOM)
	echo TARGET_CROSS=$(TARGET_CROSS)
	$(MAKE) O=$(UBOOT_BUILD_DIR) \
		CROSS_COMPILE=$(TARGET_CROSS) \
		CONFIG_NOSOFTFLOAT=1 \
		TOPDIR=$(UBOOT_DIR) \
		SRCTREE=$(UBOOT_DIR) \
		TFTPBOOT=/tftpboot \
		-C $(UBOOT_DIR)

$(BINARIES_DIR)/$(UBOOT_BIN): $(UBOOT_BUILD_DIR)/u-boot.bin
	mkdir -p $(BINARIES_DIR)
	cp $(UBOOT_BUILD_DIR)/u-boot.bin $(BINARIES_DIR)/$(UBOOT_BIN)

/tftpboot/$(UBOOT_BIN): $(UBOOT_BUILD_DIR)/u-boot.bin
	mkdir -p /tftpboot
	cp $(UBOOT_BUILD_DIR)/u-boot.bin /tftpboot/$(UBOOT_BIN)

uboot-bin: $(BINARIES_DIR)/$(UBOOT_BIN) /tftpboot/$(UBOOT_BIN)

$(UBOOT_CUSTOM).test: .config $(UBOOT_BUILD_DIR)/.configured
	echo "/* Automatically generated file, do not edit */" \
	> $(UBOOT_CUSTOM).test
ifneq ($(TARGET_HOSTNAME),)
	echo "#if defined(CONFIG_HOSTNAME)" >> $(UBOOT_CUSTOM).test
	echo "#undef CONFIG_HOSTNAME" >> $(UBOOT_CUSTOM).test
	echo "#define CONFIG_HOSTNAME $(TARGET_HOSTNAME)">> $(UBOOT_CUSTOM).test
	echo "#endif" >> $(UBOOT_CUSTOM).test
endif
ifneq ($(TARGET_UBOOT_IPADDR),)
	echo "#define CONFIG_IPADDR $(TARGET_UBOOT_IPADDR)">> $(UBOOT_CUSTOM).test
endif
ifneq ($(TARGET_UBOOT_SERVERIP),)
	echo "#define CONFIG_SERVERIP $(TARGET_UBOOT_SERVERIP)">> $(UBOOT_CUSTOM).test
endif
ifneq ($(TARGET_UBOOT_GATEWAY),)
	echo "#define CONFIG_GATEWAYIP $(TARGET_UBOOT_GATEWAY)">> $(UBOOT_CUSTOM).test
endif
ifneq ($(TARGET_UBOOT_NETMASK),)
	echo "#define CONFIG_NETMASK $(TARGET_UBOOT_NETMASK)">> $(UBOOT_CUSTOM).test
endif
ifneq ($(TARGET_UBOOT_ETHADDR),)
	echo "#define CONFIG_ETHADDR $(TARGET_UBOOT_ETHADDR)">> $(UBOOT_CUSTOM).test
endif
	diff -q $(UBOOT_CUSTOM).test $(UBOOT_CUSTOM) || cp -af $(UBOOT_CUSTOM).test $(UBOOT_CUSTOM)

$(UBOOT_SCR): .config
ifneq ($(TARGET_UBOOT_IPADDR),)
	echo setenv ipaddr $(TARGET_UBOOT_IPADDR) > $(UBOOT_SCR)
endif
ifneq ($(TARGET_UBOOT_SERVERIP),)
	echo setenv serverip $(TARGET_UBOOT_SERVERIP) >> $(UBOOT_SCR)
endif
ifneq ($(TARGET_UBOOT_GATEWAY),)
	echo setenv gatewayip $(TARGET_UBOOT_GATEWAY) >> $(UBOOT_SCR)
endif
ifneq ($(TARGET_UBOOT_NETMASK),)
	echo setenv netmask $(TARGET_UBOOT_NETMASK) >> $(UBOOT_SCR)
endif
	echo setenv linux $(BOARD_NAME)-linux-$(LINUX26_VERSION)-$(DATE).gz >> $(UBOOT_SCR)
	echo setenv kernel-version $(LINUX26_VERSION) >> $(UBOOT_SCR)
	echo setenv kernel-date $(DATE) >> $(UBOOT_SCR)
	echo setenv hostname $(TARGET_HOSTNAME) >> $(UBOOT_SCR)
	echo setenv fs-date $(DATE) >> $(UBOOT_SCR)
	echo setenv rd-1 rootfs.$(BR2_ARCH)-$(DATE).ext2 >> $(UBOOT_SCR)
	echo setenv rd-2 rootfs.$(BR2_ARCH)-$(DATE).jffs2 >> $(UBOOT_SCR)
	echo setenv rd rootfs.$(BR2_ARCH)-$(DATE).ext2 >> $(UBOOT_SCR)
	echo setenv ver 1 >> $(UBOOT_SCR)
ifneq ($(TARGET_UBOOT_ETHADDR),)
	echo setenv ethaddr $(TARGET_UBOOT_ETHADDR) >> $(UBOOT_SCR)
endif
	echo setenv fstype ram >> $(UBOOT_SCR)
	echo fs >> $(UBOOT_SCR)
	echo os >> $(UBOOT_SCR)
	echo setargs >> $(UBOOT_SCR)
	echo saveenv >> $(UBOOT_SCR)

$(UBOOT_SCR).$(PROJECT): $(UBOOT_SCR) $(MKIMAGE)
	$(MKIMAGE) -A arm \
				-O linux \
				-T script \
				-C none \
				-a 0 \
				-e 0 \
				-n "autoscr config" \
				-d $(UBOOT_SCR) \
				$(UBOOT_SCR).$(PROJECT)
	cp $(UBOOT_SCR).$(PROJECT) /tftpboot

$(MKIMAGE): $(MKIMAGE_BINLOC)
	cp -f $(MKIMAGE_BINLOC) $(MKIMAGE)

uboot: $(MKIMAGE) uboot-bin $(UBOOT_SCR).$(PROJECT)

uboot-source: $(DL_DIR)/$(UBOOT_SOURCE)

uboot-clean:
	rm -fr $(UBOOT_BUILD_DIR)
	rm -fr $(UBOOT_PATCHES)
	rm -f $(BINARIES_DIR)/$(UBOOT_BIN)
	rm -fr $(UBOOT_DIR)
	rm -f $(UBOOT_SCR)
	rm -f $(UBOOT_SCR).$(PROJECT)
# -$(MAKE) -C $(UBOOT_DIR)/uboot-tools clean

uboot-dirclean: uboot-clean
	rm -rf $(UBOOT_DIR)

uboot-new:
	rm -fr $(UBOOT_BUILD_DIR)/u-boot
	rm -fr $(UBOOT_BUILD_DIR)/u-boot.gz
	rm -fr $(UBOOT_BUILD_DIR)/u-boot.bin
	rm -fr /tftpboot/$(UBOOT_BIN)
	rm -fr $(BINARIES_DIR)/$(UBOOT_BIN)

.PHONY: uboot-bin
#############################################################
#
# Build the uboot root filesystem image
#
#############################################################

UBOOT_TARGET:=$(IMAGE).uboot

ubootroot: host-fakeroot makedevs uboot
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIPCMD) 2>/dev/null || true
	@rm -rf $(TARGET_DIR)/usr/man
	@rm -rf $(TARGET_DIR)/usr/info
	-/sbin/ldconfig -r $(TARGET_DIR) 2>/dev/null
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(STAGING_DIR)/_fakeroot.$(notdir $(UBOOT_TARGET))
	touch $(STAGING_DIR)/.fakeroot.00000
	cat $(STAGING_DIR)/.fakeroot* > $(STAGING_DIR)/_fakeroot.$(notdir $(UBOOT_TARGET))
	echo "chown -R root:root $(TARGET_DIR)" >> $(STAGING_DIR)/_fakeroot.$(notdir $(UBOOT_TARGET))
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(STAGING_DIR)/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(STAGING_DIR)/_fakeroot.$(notdir $(UBOOT_TARGET))
	# Use fakeroot so mkuboot believes the previous fakery
	echo "$(UBOOT_DIR)/uboot-tools/mkuboot " \
		    "$(TARGET_DIR) $(UBOOT_TARGET) " \
		    "-noappend $(UBOOT_ENDIANNESS)" \
		>> $(STAGING_DIR)/_fakeroot.$(notdir $(UBOOT_TARGET))
	chmod a+x $(STAGING_DIR)/_fakeroot.$(notdir $(UBOOT_TARGET))
	$(STAGING_DIR)/usr/bin/fakeroot -- $(STAGING_DIR)/_fakeroot.$(notdir $(UBOOT_TARGET))
	-@rm -f $(STAGING_DIR)/_fakeroot.$(notdir $(UBOOT_TARGET))

ubootroot-source: uboot-source

ubootroot-clean:
	-$(MAKE) -C $(UBOOT_DIR) clean

ubootroot-dirclean:
	rm -rf $(UBOOT_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_TARGET_UBOOT_AT91)),y)
TARGETS+=uboot
endif

uboot-test:
	-@echo source=$(DL_DIR)/$(UBOOT_SOURCE)
	-@ls $(DL_DIR)/$(UBOOT_SOURCE)
	-@echo patch=$(DL_DIR)/$(UBOOT_PATCH_SOURCE)
	-@ls $(DL_DIR)/$(UBOOT_PATCH_SOURCE)
	-@echo unpacked=$(UBOOT_PATCHES)/.unpacked
	-@ls $(UBOOT_PATCHES)/.unpacked
	-@echo patch-unpacked=$(UBOOT_PATCHES)/.unpacked
	-@ls $(UBOOT_PATCHES)/.unpacked
	-@echo patched-source=$(UBOOT_DIR)/.patched.$(UBOOT_PATCH_SOURCE)
	-@ls $(UBOOT_DIR)/.patched.$(UBOOT_PATCH_SOURCE)
	-@echo configured=$(UBOOT_BUILD_DIR)/.configured
	-@ls $(UBOOT_BUILD_DIR)/.configured
	-@echo mkimage=$(MKIMAGE_BINLOC)
	-@ls $(MKIMAGE_BINLOC)
	-@echo u-boot.bin=$(UBOOT_BUILD_DIR)/u-boot.bin
	-@ls $(UBOOT_BUILD_DIR)/u-boot.bin
	-@echo binaries-u-boot.bin=$(BINARIES_DIR)/$(UBOOT_BIN)
	-@ls $(BINARIES_DIR)/$(UBOOT_BIN)
	-@echo tftpboot=/tftpboot/$(UBOOT_BIN)
	-@ls /tftpboot/$(UBOOT_BIN)
	-@echo "mkimage = $(MKIMAGE)"
	-@ls $(MKIMAGE)
	-@echo "u-boot script=$(UBOOT_SCR).$(PROJECT)"
	-@ls $(UBOOT_SCR).$(PROJECT)
	-@echo "u-boot script (ASCII)=$(UBOOT_SCR)"
	-@ls $(UBOOT_SCR)
	-@echo "mkimage binary=$(MKIMAGE_BINLOC)"
	-@ls $(MKIMAGE_BINLOC)
