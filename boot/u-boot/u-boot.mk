#############################################################
#
# U-Boot
#
#############################################################
U_BOOT_VERSION:=$(call qstrip,$(BR2_TARGET_UBOOT_VERSION))
U_BOOT_BOARD_NAME:=$(call qstrip,$(BR2_TARGET_UBOOT_BOARDNAME))

# U-Boot may not be selected in the configuration, but mkimage might
# be needed to build/prepare a kernel image. In this case, we just
# pick some random stable U-Boot version that will be used just to
# build mkimage.
ifeq ($(U_BOOT_VERSION),)
U_BOOT_VERSION=2010.12
endif

ifeq ($(U_BOOT_VERSION),custom)
# Handle custom U-Boot tarballs as specified by the configuration
U_BOOT_TARBALL=$(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_TARBALL_LOCATION))
U_BOOT_SITE:=$(dir $(U_BOOT_TARBALL))
U_BOOT_SOURCE:=$(notdir $(U_BOOT_TARBALL))
else
# Handle stable official U-Boot versions
U_BOOT_SITE:=ftp://ftp.denx.de/pub/u-boot
U_BOOT_SOURCE:=u-boot-$(U_BOOT_VERSION).tar.bz2
endif

U_BOOT_DIR:=$(BUILD_DIR)/u-boot-$(U_BOOT_VERSION)
U_BOOT_CAT:=$(BZCAT)

ifeq ($(BR2_TARGET_UBOOT_FORMAT_KWB),y)
U_BOOT_BIN:=u-boot.kwb
U_BOOT_MAKE_OPT:=$(U_BOOT_BIN)
else ifeq ($(BR2_TARGET_UBOOT_FORMAT_LDR),y)
U_BOOT_BIN:=u-boot.ldr
else
U_BOOT_BIN:=u-boot.bin
endif

MKIMAGE:=$(HOST_DIR)/usr/bin/mkimage

U_BOOT_TARGETS:=$(BINARIES_DIR)/$(U_BOOT_BIN) $(MKIMAGE)
U_BOOT_ARCH=$(KERNEL_ARCH)

# u-boot in the past used arch=ppc for powerpc
ifneq ($(findstring x200,x$(U_BOOT_VERSION))$(findstring x2010.03,x$(U_BOOT_VERSION)),)
U_BOOT_ARCH=$(KERNEL_ARCH:powerpc=ppc)
endif

U_BOOT_INC_CONF_FILE:=$(U_BOOT_DIR)/include/config.h

ifeq ($(BR2_TARGET_UBOOT_TOOL_MKIMAGE),y)
U_BOOT_TARGETS+=$(TARGET_DIR)/usr/bin/mkimage
endif
ifeq ($(BR2_TARGET_UBOOT_TOOL_ENV),y)
U_BOOT_TARGETS+=$(TARGET_DIR)/usr/sbin/fw_printenv
endif

U_BOOT_CONFIGURE_OPTS += CONFIG_NOSOFTFLOAT=1

# Define a helper function
define insert_define
@echo "#ifdef $(strip $(1))" >> $(U_BOOT_INC_CONF_FILE)
@echo "#undef $(strip $(1))" >> $(U_BOOT_INC_CONF_FILE)
@echo "#endif" >> $(U_BOOT_INC_CONF_FILE)
@echo '#define $(strip $(1)) $(call qstrip,$(2))' >> $(U_BOOT_INC_CONF_FILE)
endef

$(DL_DIR)/$(U_BOOT_SOURCE):
	 $(call DOWNLOAD,$(U_BOOT_SITE),$(U_BOOT_SOURCE))

$(U_BOOT_DIR)/.unpacked: $(DL_DIR)/$(U_BOOT_SOURCE)
	mkdir -p $(@D)
	$(INFLATE$(suffix $(U_BOOT_SOURCE))) $(DL_DIR)/$(U_BOOT_SOURCE) \
		| tar $(TAR_STRIP_COMPONENTS)=1 -C $(@D) $(TAR_OPTIONS) -
	touch $@

$(U_BOOT_DIR)/.patched: $(U_BOOT_DIR)/.unpacked
	toolchain/patch-kernel.sh $(U_BOOT_DIR) boot/u-boot \
		u-boot-$(U_BOOT_VERSION)-\*.patch \
		u-boot-$(U_BOOT_VERSION)-\*.patch.$(ARCH)
ifneq ($(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_PATCH_DIR)),)
	toolchain/patch-kernel.sh $(U_BOOT_DIR) $(BR2_TARGET_UBOOT_CUSTOM_PATCH_DIR) u-boot-$(U_BOOT_VERSION)-\*.patch
endif
	touch $@

$(U_BOOT_DIR)/.configured: $(U_BOOT_DIR)/.patched
ifeq ($(U_BOOT_BOARD_NAME),)
	$(error NO U-Boot board name set. Check your BR2_TARGET_UBOOT_BOARDNAME setting)
endif
	$(TARGET_CONFIGURE_OPTS)		\
		$(U_BOOT_CONFIGURE_OPTS) \
		$(MAKE) -C $(U_BOOT_DIR) \
		CROSS_COMPILE="$(TARGET_CROSS)" ARCH=$(U_BOOT_ARCH) \
		$(U_BOOT_BOARD_NAME)_config
	touch $@

$(U_BOOT_DIR)/.header_modified: $(U_BOOT_DIR)/.configured
	# Modify configuration header in $(U_BOOT_INC_CONF_FILE)
ifdef BR2_TARGET_UBOOT_NETWORK
	@echo >> $(U_BOOT_INC_CONF_FILE)
	@echo "/* Add a wrapper around the values Buildroot sets. */" >> $(U_BOOT_INC_CONF_FILE)
	@echo "#ifndef __BR2_ADDED_CONFIG_H" >> $(U_BOOT_INC_CONF_FILE)
	@echo "#define __BR2_ADDED_CONFIG_H" >> $(U_BOOT_INC_CONF_FILE)
	$(call insert_define, DATE, $(DATE))
	$(call insert_define, CONFIG_LOAD_SCRIPTS, 1)
ifneq ($(strip $(BR2_TARGET_UBOOT_IPADDR)),"")
	$(call insert_define, CONFIG_IPADDR, $(BR2_TARGET_UBOOT_IPADDR))
endif
ifneq ($(strip $(BR2_TARGET_UBOOT_GATEWAY)),"")
	$(call insert_define, CONFIG_GATEWAYIP, $(BR2_TARGET_UBOOT_GATEWAY))
endif
ifneq ($(strip $(BR2_TARGET_UBOOT_NETMASK)),"")
	$(call insert_define, CONFIG_NETMASK, $(BR2_TARGET_UBOOT_NETMASK))
endif
ifneq ($(strip $(BR2_TARGET_UBOOT_SERVERIP)),"")
	$(call insert_define, CONFIG_SERVERIP, $(BR2_TARGET_UBOOT_SERVERIP))
endif
ifneq ($(strip $(BR2_TARGET_UBOOT_ETHADDR)),"")
	$(call insert_define, CONFIG_ETHADDR, $(BR2_TARGET_UBOOT_ETHADDR))
endif
ifneq ($(strip $(BR2_TARGET_UBOOT_ETH1ADDR)),"")
	$(call insert_define, CONFIG_ETH1ADDR, $(BR2_TARGET_UBOOT_ETH1ADDR))
endif
	@echo "#endif /* __BR2_ADDED_CONFIG_H */" >> $(U_BOOT_INC_CONF_FILE)
endif # BR2_TARGET_UBOOT_NETWORK
	touch $@

# Build U-Boot itself
$(U_BOOT_DIR)/$(U_BOOT_BIN): $(U_BOOT_DIR)/.header_modified
	$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		$(U_BOOT_CONFIGURE_OPTS) \
		$(MAKE) CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)" ARCH=$(U_BOOT_ARCH) \
		$(U_BOOT_MAKE_OPT) -C $(U_BOOT_DIR)

# Copy the result to the images/ directory
$(BINARIES_DIR)/$(U_BOOT_BIN): $(U_BOOT_DIR)/$(U_BOOT_BIN)
	rm -f $(BINARIES_DIR)/$(U_BOOT_BIN)
	cp -dpf $(U_BOOT_DIR)/$(U_BOOT_BIN) $(BINARIES_DIR)/

# Build just mkimage for the host. It might have already been built by
# the U-Boot build procedure, but mkimage may also be needed even if
# U-Boot isn't selected in the configuration, to generate a kernel
# uImage.
$(MKIMAGE): $(U_BOOT_DIR)/.patched
	mkdir -p $(@D)
	$(MAKE) -C $(U_BOOT_DIR) CROSS_COMPILE="$(TARGET_CROSS)" ARCH=$(U_BOOT_ARCH) tools
	cp -dpf $(U_BOOT_DIR)/tools/mkimage $(@D)

# Build manually mkimage for the target
$(TARGET_DIR)/usr/bin/mkimage: $(U_BOOT_DIR)/.configured
	mkdir -p $(@D)
	$(TARGET_CC) -I$(U_BOOT_DIR)/include -I$(U_BOOT_DIR)/tools \
		-DUSE_HOSTCC -o $@ \
		$(U_BOOT_DIR)/common/image.c \
		$(wildcard $(addprefix $(U_BOOT_DIR)/tools/,default_image.c \
			fit_image.c imximage.c kwbimage.c mkimage.c)) \
		$(addprefix $(U_BOOT_DIR)/lib*/,crc32.c md5.c sha1.c) \
		$(U_BOOT_DIR)/tools/os_support.c \
		$(wildcard $(U_BOOT_DIR)/libfdt/fdt*.c $(U_BOOT_DIR)/lib/libfdt/fdt*.c)

	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $@

# Build manually fw_printenv for the target
$(TARGET_DIR)/usr/sbin/fw_printenv: $(U_BOOT_DIR)/.configured
	mkdir -p $(@D)
	$(TARGET_CC) -I$(U_BOOT_DIR)/include -I$(LINUX_HEADERS_DIR)/include \
		-DUSE_HOSTCC -o $@ \
		$(U_BOOT_DIR)/tools/env/*.c $(U_BOOT_DIR)/lib*/crc32.c
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $@
	ln -sf fw_printenv $(TARGET_DIR)/usr/sbin/fw_setenv

u-boot: $(U_BOOT_TARGETS)

u-boot-clean:
	-$(MAKE) -C $(U_BOOT_DIR) clean
	rm -f $(MKIMAGE)

u-boot-dirclean:
	rm -rf $(U_BOOT_DIR)

u-boot-source: $(DL_DIR)/$(U_BOOT_SOURCE)

u-boot-unpacked: $(U_BOOT_DIR)/.patched

u-boot-configured: $(U_BOOT_DIR)/.header_modified

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_UBOOT),y)
TARGETS+=u-boot

# we NEED a board name unless we're at make source
ifeq ($(filter source,$(MAKECMDGOALS)),)
ifeq ($(U_BOOT_BOARD_NAME),)
$(error NO U-Boot board name set. Check your BR2_TARGET_UBOOT_BOARDNAME setting)
endif
endif

endif
