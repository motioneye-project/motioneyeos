################################################################################
#
# sunxi-tools
#
################################################################################

SUNXI_TOOLS_VERSION = v1.3
SUNXI_TOOLS_SITE = $(call github,linux-sunxi,sunxi-tools,$(SUNXI_TOOLS_VERSION))
SUNXI_TOOLS_LICENSE = GPLv2+
SUNXI_TOOLS_LICENSE_FILES = COPYING
HOST_SUNXI_TOOLS_DEPENDENCIES = host-libusb host-pkgconf
FEX2BIN = $(HOST_DIR)/usr/bin/fex2bin

define HOST_SUNXI_TOOLS_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) PREFIX=$(HOST_DIR)/usr \
		CFLAGS="$(HOST_CFLAGS) -std=c99 -D_POSIX_C_SOURCE=200112L -Iinclude/" \
		-C $(@D) tools
endef

define HOST_SUNXI_TOOLS_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) PREFIX=$(HOST_DIR)/usr \
		-C $(@D) install-tools
endef

define SUNXI_TOOLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) PREFIX=/usr \
		CFLAGS="$(TARGET_CFLAGS) -std=c99 -D_POSIX_C_SOURCE=200112L -Iinclude/" \
		-C $(@D) sunxi-nand-part
endef

define SUNXI_TOOLS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/sunxi-nand-part $(TARGET_DIR)/usr/bin/sunxi-nand-part
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
