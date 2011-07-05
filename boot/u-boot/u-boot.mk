#############################################################
#
# U-Boot
#
#############################################################
U_BOOT_VERSION    = $(call qstrip,$(BR2_TARGET_UBOOT_VERSION))
U_BOOT_BOARD_NAME = $(call qstrip,$(BR2_TARGET_UBOOT_BOARDNAME))

U_BOOT_INSTALL_IMAGES = YES

ifeq ($(U_BOOT_VERSION),custom)
# Handle custom U-Boot tarballs as specified by the configuration
U_BOOT_TARBALL = $(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_TARBALL_LOCATION))
U_BOOT_SITE    = $(dir $(U_BOOT_TARBALL))
U_BOOT_SOURCE  = $(notdir $(U_BOOT_TARBALL))
else
# Handle stable official U-Boot versions
U_BOOT_SITE    = ftp://ftp.denx.de/pub/u-boot
U_BOOT_SOURCE  = u-boot-$(U_BOOT_VERSION).tar.bz2
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_KWB),y)
U_BOOT_BIN          = u-boot.kwb
U_BOOT_MAKE_TARGET  = $(U_BOOT_BIN)
else ifeq ($(BR2_TARGET_UBOOT_FORMAT_LDR),y)
U_BOOT_BIN          = u-boot.ldr
else
U_BOOT_BIN          = u-boot.bin
endif

U_BOOT_ARCH=$(KERNEL_ARCH)

# u-boot in the past used arch=ppc for powerpc
ifneq ($(findstring x2010.03,x$(U_BOOT_VERSION)),)
U_BOOT_ARCH=$(KERNEL_ARCH:powerpc=ppc)
endif

U_BOOT_CONFIGURE_OPTS += CONFIG_NOSOFTFLOAT=1
U_BOOT_MAKE_OPTS += \
	CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)" \
	ARCH=$(U_BOOT_ARCH)

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
define U_BOOT_APPLY_CUSTOM_PATCHES
	toolchain/patch-kernel.sh $(@D) $(BR2_TARGET_UBOOT_CUSTOM_PATCH_DIR) \
		u-boot-$(U_BOOT_VERSION)-\*.patch
endef

U_BOOT_POST_PATCH_HOOKS += U_BOOT_APPLY_CUSTOM_PATCHES
endif

define U_BOOT_CONFIGURE_CMDS
	$(TARGET_CONFIGURE_OPTS) $(U_BOOT_CONFIGURE_OPTS) 	\
		$(MAKE) -C $(@D) $(U_BOOT_MAKE_OPTS)		\
		$(U_BOOT_BOARD_NAME)_config
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

ifeq ($(BR2_TARGET_UBOOT_TOOL_ENV),y)
define U_BOOT_BUILD_TARGET_ENV_UTILS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) HOSTCC="$(TARGET_CC)" -C $(@D) env
endef
endif

define U_BOOT_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(U_BOOT_CONFIGURE_OPTS) 	\
		$(MAKE) -C $(@D) $(U_BOOT_MAKE_OPTS) 		\
		$(U_BOOT_MAKE_TARGET)
	$(U_BOOT_BUILD_TARGET_ENV_UTILS)
endef

define U_BOOT_INSTALL_IMAGES_CMDS
	cp -dpf $(@D)/$(U_BOOT_BIN) $(BINARIES_DIR)/
endef

ifeq ($(BR2_TARGET_UBOOT_TOOL_ENV),y)
define U_BOOT_INSTALL_TARGET_ENV_UTILS
	$(INSTALL) -m 0755 -D $(@D)/tools/env/fw_printenv \
		$(TARGET_DIR)/usr/sbin/fw_printenv
	ln -sf fw_printenv $(TARGET_DIR)/usr/sbin/fw_setenv
endef
endif

define U_BOOT_INSTALL_TARGET_CMDS
	$(U_BOOT_INSTALL_TARGET_ENV_UTILS)
endef

$(eval $(call GENTARGETS,boot,u-boot))

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
