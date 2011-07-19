#############################################################
#
# U-Boot
#
#############################################################
UBOOT_VERSION    = $(call qstrip,$(BR2_TARGET_UBOOT_VERSION))
UBOOT_BOARD_NAME = $(call qstrip,$(BR2_TARGET_UBOOT_BOARDNAME))

UBOOT_INSTALL_IMAGES = YES

ifeq ($(UBOOT_VERSION),custom)
# Handle custom U-Boot tarballs as specified by the configuration
UBOOT_TARBALL = $(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_TARBALL_LOCATION))
UBOOT_SITE    = $(dir $(UBOOT_TARBALL))
UBOOT_SOURCE  = $(notdir $(UBOOT_TARBALL))
else ifeq ($(BR2_TARGET_UBOOT_CUSTOM_GIT),y)
UBOOT_SITE        = $(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_GIT_REPO_URL))
UBOOT_SITE_METHOD = git
else
# Handle stable official U-Boot versions
UBOOT_SITE    = ftp://ftp.denx.de/pub/u-boot
UBOOT_SOURCE  = u-boot-$(UBOOT_VERSION).tar.bz2
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_KWB),y)
UBOOT_BIN          = u-boot.kwb
UBOOT_MAKE_TARGET  = $(UBOOT_BIN)
else ifeq ($(BR2_TARGET_UBOOT_FORMAT_LDR),y)
UBOOT_BIN          = u-boot.ldr
else
UBOOT_BIN          = u-boot.bin
endif

UBOOT_ARCH=$(KERNEL_ARCH)

UBOOT_CONFIGURE_OPTS += CONFIG_NOSOFTFLOAT=1
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

ifneq ($(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_PATCH_DIR)),)
define UBOOT_APPLY_CUSTOM_PATCHES
	toolchain/patch-kernel.sh $(@D) $(BR2_TARGET_UBOOT_CUSTOM_PATCH_DIR) \
		uboot-$(UBOOT_VERSION)-\*.patch
endef

UBOOT_POST_PATCH_HOOKS += UBOOT_APPLY_CUSTOM_PATCHES
endif

define UBOOT_CONFIGURE_CMDS
	$(TARGET_CONFIGURE_OPTS) $(UBOOT_CONFIGURE_OPTS) 	\
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
	$(TARGET_CONFIGURE_OPTS) $(UBOOT_CONFIGURE_OPTS) 	\
		$(MAKE) -C $(@D) $(UBOOT_MAKE_OPTS) 		\
		$(UBOOT_MAKE_TARGET)
endef

define UBOOT_INSTALL_IMAGES_CMDS
	cp -dpf $(@D)/$(UBOOT_BIN) $(BINARIES_DIR)/
endef

$(eval $(call GENTARGETS,boot,uboot))

ifeq ($(BR2_TARGET_UBOOT),y)
# we NEED a board name unless we're at make source
ifeq ($(filter source,$(MAKECMDGOALS)),)
ifeq ($(UBOOT_BOARD_NAME),)
$(error NO U-Boot board name set. Check your BR2_TARGET_UBOOT_BOARDNAME setting)
endif
endif
endif
