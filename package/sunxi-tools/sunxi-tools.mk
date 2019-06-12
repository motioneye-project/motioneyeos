################################################################################
#
# sunxi-tools
#
################################################################################

SUNXI_TOOLS_VERSION = 1.4.1
SUNXI_TOOLS_SITE = $(call github,linux-sunxi,sunxi-tools,v$(SUNXI_TOOLS_VERSION))
SUNXI_TOOLS_LICENSE = GPL-2.0+
SUNXI_TOOLS_LICENSE_FILES = LICENSE.md
HOST_SUNXI_TOOLS_DEPENDENCIES = host-libusb host-pkgconf
FEX2BIN = $(HOST_DIR)/bin/fex2bin

SUNXI_TOOLS_TARGETS_$(BR2_PACKAGE_SUNXI_TOOLS_FEXC) += sunxi-fexc
SUNXI_TOOLS_TARGETS_$(BR2_PACKAGE_SUNXI_TOOLS_BOOTINFO) += sunxi-bootinfo
SUNXI_TOOLS_TARGETS_$(BR2_PACKAGE_SUNXI_TOOLS_FEL) += sunxi-fel
SUNXI_TOOLS_TARGETS_$(BR2_PACKAGE_SUNXI_TOOLS_NAND_PART) += sunxi-nand-part
SUNXI_TOOLS_TARGETS_$(BR2_PACKAGE_SUNXI_TOOLS_PIO) += sunxi-pio
SUNXI_TOOLS_TARGETS_$(BR2_PACKAGE_SUNXI_TOOLS_MEMINFO) += sunxi-meminfo
SUNXI_TOOLS_TARGETS_$(BR2_PACKAGE_SUNXI_TOOLS_PHOENIX_INFO) += phoenix_info
SUNXI_TOOLS_TARGETS_$(BR2_PACKAGE_SUNXI_TOOLS_NAND_IMAGE_BUILDER) += \
	sunxi-nand-image-builder

ifeq ($(BR2_PACKAGE_SUNXI_TOOLS_FEXC),y)
SUNXI_TOOLS_FEXC_LINKS += fex2bin bin2fex
endif

ifeq ($(BR2_PACKAGE_SUNXI_TOOLS_FEL),y)
SUNXI_TOOLS_DEPENDENCIES += libusb host-pkgconf
endif

define HOST_SUNXI_TOOLS_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) CROSS_COMPILE="" CC="$(HOSTCC)" \
		PREFIX=$(HOST_DIR) EXTRA_CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" -C $(@D) tools misc
endef

define HOST_SUNXI_TOOLS_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) CROSS_COMPILE="" CC="$(HOSTCC)" \
		PREFIX=$(HOST_DIR) EXTRA_CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)"  -C $(@D) install-tools install-misc
endef

define SUNXI_TOOLS_BUILD_CMDS
	$(foreach t,$(SUNXI_TOOLS_TARGETS_y), \
		$(TARGET_MAKE_ENV) $(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" \
			CC="$(TARGET_CC)" PREFIX=/usr \
			EXTRA_CFLAGS="$(TARGET_CFLAGS)" \
			LDFLAGS="$(TARGET_LDFLAGS)" -C $(@D) $(t)
	)
endef

define SUNXI_TOOLS_INSTALL_TARGET_CMDS
	$(foreach t,$(SUNXI_TOOLS_TARGETS_y), \
		$(INSTALL) -D -m 0755 $(@D)/$(t) $(TARGET_DIR)/usr/bin/$(t)
	)
	$(foreach t,$(SUNXI_TOOLS_FEXC_LINKS), \
		ln -nfs sunxi-fexc $(TARGET_DIR)/usr/bin/$(t)
	)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
