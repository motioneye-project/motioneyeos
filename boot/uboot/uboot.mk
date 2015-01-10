################################################################################
#
# uboot
#
################################################################################

UBOOT_VERSION = $(call qstrip,$(BR2_TARGET_UBOOT_VERSION))
UBOOT_BOARD_NAME = $(call qstrip,$(BR2_TARGET_UBOOT_BOARDNAME))

UBOOT_LICENSE = GPLv2+
UBOOT_LICENSE_FILES = Licenses/gpl-2.0.txt

UBOOT_INSTALL_IMAGES = YES

ifeq ($(UBOOT_VERSION),custom)
# Handle custom U-Boot tarballs as specified by the configuration
UBOOT_TARBALL = $(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_TARBALL_LOCATION))
UBOOT_SITE = $(patsubst %/,%,$(dir $(UBOOT_TARBALL)))
UBOOT_SOURCE = $(notdir $(UBOOT_TARBALL))
else ifeq ($(BR2_TARGET_UBOOT_CUSTOM_GIT),y)
UBOOT_SITE = $(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_REPO_URL))
UBOOT_SITE_METHOD = git
else ifeq ($(BR2_TARGET_UBOOT_CUSTOM_HG),y)
UBOOT_SITE = $(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_REPO_URL))
UBOOT_SITE_METHOD = hg
else
# Handle stable official U-Boot versions
UBOOT_SITE = ftp://ftp.denx.de/pub/u-boot
UBOOT_SOURCE = u-boot-$(UBOOT_VERSION).tar.bz2
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_ELF),y)
UBOOT_BIN = u-boot
else ifeq ($(BR2_TARGET_UBOOT_FORMAT_KWB),y)
UBOOT_BIN = u-boot.kwb
UBOOT_MAKE_TARGET = $(UBOOT_BIN)
else ifeq ($(BR2_TARGET_UBOOT_FORMAT_AIS),y)
UBOOT_BIN = u-boot.ais
UBOOT_MAKE_TARGET = $(UBOOT_BIN)
else ifeq ($(BR2_TARGET_UBOOT_FORMAT_LDR),y)
UBOOT_BIN = u-boot.ldr
else ifeq ($(BR2_TARGET_UBOOT_FORMAT_NAND_BIN),y)
UBOOT_BIN = u-boot-nand.bin
else ifeq ($(BR2_TARGET_UBOOT_FORMAT_IMG),y)
UBOOT_BIN = u-boot.img
else ifeq ($(BR2_TARGET_UBOOT_FORMAT_IMX),y)
UBOOT_BIN = u-boot.imx
else ifeq ($(BR2_TARGET_UBOOT_FORMAT_SB),y)
UBOOT_BIN = u-boot.sb
UBOOT_MAKE_TARGET = $(UBOOT_BIN)
UBOOT_DEPENDENCIES += host-elftosb
else ifeq ($(BR2_TARGET_UBOOT_FORMAT_CUSTOM),y)
UBOOT_BIN = $(call qstrip,$(BR2_TARGET_UBOOT_FORMAT_CUSTOM_NAME))
else
UBOOT_BIN = u-boot.bin
UBOOT_BIN_IFT = $(UBOOT_BIN).ift
endif

UBOOT_ARCH = $(KERNEL_ARCH)

UBOOT_MAKE_OPTS += \
	CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)" \
	ARCH=$(UBOOT_ARCH)

# Helper function to fill the U-Boot config.h file.
# Argument 1: option name
# Argument 2: option value
# If the option value is empty, this function does nothing.
define insert_define
$(if $(call qstrip,$(2)),
	@echo "#ifdef $(strip $(1))" >> $(@D)/include/config.h
	@echo "#undef $(strip $(1))" >> $(@D)/include/config.h
	@echo "#endif" >> $(@D)/include/config.h
	@echo '#define $(strip $(1)) $(call qstrip,$(2))' >> $(@D)/include/config.h)
endef

# prior to u-boot 2013.10 the license info was in COPYING. Copy it so
# legal-info finds it
define UBOOT_COPY_OLD_LICENSE_FILE
	if [ -f $(@D)/COPYING ]; then \
		$(INSTALL) -m 0644 -D $(@D)/COPYING $(@D)/Licenses/gpl-2.0.txt; \
	fi
endef

UBOOT_POST_EXTRACT_HOOKS += UBOOT_COPY_OLD_LICENSE_FILE

ifneq ($(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_PATCH_DIR)),)
define UBOOT_APPLY_CUSTOM_PATCHES
	$(APPLY_PATCHES) $(@D) $(BR2_TARGET_UBOOT_CUSTOM_PATCH_DIR) \
		uboot-\*.patch
endef

UBOOT_POST_PATCH_HOOKS += UBOOT_APPLY_CUSTOM_PATCHES
endif

define UBOOT_CONFIGURE_CMDS
	$(TARGET_CONFIGURE_OPTS) 	\
		$(MAKE) -C $(@D) $(UBOOT_MAKE_OPTS)		\
		$(UBOOT_BOARD_NAME)_config
	@echo >> $(@D)/include/config.h
	@echo "/* Add a wrapper around the values Buildroot sets. */" >> $(@D)/include/config.h
	@echo "#ifndef __BR2_ADDED_CONFIG_H" >> $(@D)/include/config.h
	@echo "#define __BR2_ADDED_CONFIG_H" >> $(@D)/include/config.h
	$(call insert_define,DATE,$(DATE))
	$(call insert_define,CONFIG_LOAD_SCRIPTS,1)
	$(call insert_define,CONFIG_IPADDR,$(BR2_TARGET_UBOOT_IPADDR))
	$(call insert_define,CONFIG_GATEWAYIP,$(BR2_TARGET_UBOOT_GATEWAY))
	$(call insert_define,CONFIG_NETMASK,$(BR2_TARGET_UBOOT_NETMASK))
	$(call insert_define,CONFIG_SERVERIP,$(BR2_TARGET_UBOOT_SERVERIP))
	$(call insert_define,CONFIG_ETHADDR,$(BR2_TARGET_UBOOT_ETHADDR))
	$(call insert_define,CONFIG_ETH1ADDR,$(BR2_TARGET_UBOOT_ETH1ADDR))
	@echo "#endif /* __BR2_ADDED_CONFIG_H */" >> $(@D)/include/config.h
endef

define UBOOT_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) 	\
		$(MAKE) -C $(@D) $(UBOOT_MAKE_OPTS) 		\
		$(UBOOT_MAKE_TARGET)
endef

define UBOOT_BUILD_OMAP_IFT
	$(HOST_DIR)/usr/bin/gpsign -f $(@D)/u-boot.bin \
		-c $(call qstrip,$(BR2_TARGET_UBOOT_OMAP_IFT_CONFIG))
endef

define UBOOT_INSTALL_IMAGES_CMDS
	cp -dpf $(@D)/$(UBOOT_BIN) $(BINARIES_DIR)/
	$(if $(BR2_TARGET_UBOOT_SPL),
		cp -dpf $(@D)/$(call qstrip,$(BR2_TARGET_UBOOT_SPL_NAME)) $(BINARIES_DIR)/)
	$(if $(BR2_TARGET_UBOOT_ENVIMAGE),
		$(HOST_DIR)/usr/bin/mkenvimage -s $(BR2_TARGET_UBOOT_ENVIMAGE_SIZE) \
		$(if $(BR2_TARGET_UBOOT_ENVIMAGE_REDUNDANT),-r) \
		-o $(BINARIES_DIR)/uboot-env.bin $(BR2_TARGET_UBOOT_ENVIMAGE_SOURCE))
endef

define UBOOT_INSTALL_OMAP_IFT_IMAGE
	cp -dpf $(@D)/$(UBOOT_BIN_IFT) $(BINARIES_DIR)/
endef

ifeq ($(BR2_TARGET_UBOOT_OMAP_IFT),y)
# we NEED a config file unless we're at make source
ifeq ($(filter source,$(MAKECMDGOALS)),)
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_OMAP_IFT_CONFIG)),)
$(error No gpsign config file. Check your BR2_TARGET_UBOOT_OMAP_IFT_CONFIG setting)
endif
ifeq ($(wildcard $(call qstrip,$(BR2_TARGET_UBOOT_OMAP_IFT_CONFIG))),)
$(error gpsign config file $(BR2_TARGET_UBOOT_OMAP_IFT_CONFIG) not found. Check your BR2_TARGET_UBOOT_OMAP_IFT_CONFIG setting)
endif
endif
UBOOT_DEPENDENCIES += host-omap-u-boot-utils
UBOOT_POST_BUILD_HOOKS += UBOOT_BUILD_OMAP_IFT
UBOOT_POST_INSTALL_IMAGES_HOOKS += UBOOT_INSTALL_OMAP_IFT_IMAGE
endif

ifeq ($(BR2_TARGET_UBOOT_ENVIMAGE),y)
# we NEED a environment settings unless we're at make source
ifeq ($(filter source,$(MAKECMDGOALS)),)
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_ENVIMAGE_SOURCE)),)
$(error Please define a source file for Uboot environment (BR2_TARGET_UBOOT_ENVIMAGE_SOURCE setting))
endif
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_ENVIMAGE_SIZE)),)
$(error Please provide Uboot environment size (BR2_TARGET_UBOOT_ENVIMAGE_SIZE setting))
endif
endif
UBOOT_DEPENDENCIES += host-uboot-tools
endif

$(eval $(generic-package))

ifeq ($(BR2_TARGET_UBOOT),y)
# we NEED a board name unless we're at make source
ifeq ($(filter source,$(MAKECMDGOALS)),)
ifeq ($(UBOOT_BOARD_NAME),)
$(error NO U-Boot board name set. Check your BR2_TARGET_UBOOT_BOARDNAME setting)
endif

ifeq ($(BR2_TARGET_UBOOT_CUSTOM_VERSION),y)
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_VERSION_VALUE)),)
$(error No custom U-Boot version specified. Check your BR2_TARGET_UBOOT_CUSTOM_VERSION_VALUE setting)
endif # qstrip BR2_TARGET_UBOOT_CUSTOM_VERSION_VALUE
endif # BR2_TARGET_UBOOT_CUSTOM_VERSION

ifeq ($(BR2_TARGET_UBOOT_CUSTOM_TARBALL),y)
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_TARBALL_LOCATION)),)
$(error No custom U-Boot tarball specified. Check your BR2_TARGET_UBOOT_CUSTOM_TARBALL_LOCATION setting)
endif # qstrip BR2_TARGET_UBOOT_CUSTOM_TARBALL_LOCATION
endif # BR2_TARGET_UBOOT_CUSTOM_TARBALL

ifeq ($(BR2_TARGET_UBOOT_CUSTOM_GIT)$(BR2_TARGET_UBOOT_CUSTOM_HG),y)
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_REPO_URL)),)
$(error No custom U-Boot repository URL specified. Check your BR2_TARGET_UBOOT_CUSTOM_REPO_URL setting)
endif # qstrip BR2_TARGET_UBOOT_CUSTOM_CUSTOM_REPO_URL
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION)),)
$(error No custom U-Boot repository URL specified. Check your BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION setting)
endif # qstrip BR2_TARGET_UBOOT_CUSTOM_CUSTOM_REPO_VERSION
endif # BR2_TARGET_UBOOT_CUSTOM_GIT || BR2_TARGET_UBOOT_CUSTOM_HG

endif # filter source
endif # BR2_TARGET_UBOOT
