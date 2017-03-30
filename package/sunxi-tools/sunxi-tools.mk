################################################################################
#
# sunxi-tools
#
################################################################################

SUNXI_TOOLS_VERSION = v1.4.1
SUNXI_TOOLS_SITE = $(call github,linux-sunxi,sunxi-tools,$(SUNXI_TOOLS_VERSION))
SUNXI_TOOLS_LICENSE = GPL-2.0+
SUNXI_TOOLS_LICENSE_FILES = LICENSE.md
HOST_SUNXI_TOOLS_DEPENDENCIES = host-libusb host-pkgconf
FEX2BIN = $(HOST_DIR)/usr/bin/fex2bin

define HOST_SUNXI_TOOLS_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) CC="$(HOSTCC)" PREFIX=$(HOST_DIR)/usr \
		EXTRA_CFLAGS="$(HOST_CFLAGS)" LDFLAGS="$(HOST_LDFLAGS)" \
		-C $(@D) tools
endef

define HOST_SUNXI_TOOLS_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) PREFIX=$(HOST_DIR)/usr \
		-C $(@D) install-tools
endef

define SUNXI_TOOLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" PREFIX=/usr \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" \
		-C $(@D) sunxi-nand-part
endef

define SUNXI_TOOLS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/sunxi-nand-part $(TARGET_DIR)/usr/bin/sunxi-nand-part
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
