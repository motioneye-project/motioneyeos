################################################################################
#
# sunxi-tools
#
################################################################################

SUNXI_TOOLS_VERSION = 3a94e721dd8d1e13d0b25da0a83463891e8e9ee0
SUNXI_TOOLS_SITE = $(call github,linux-sunxi,sunxi-tools,$(SUNXI_TOOLS_VERSION))
SUNXI_TOOLS_LICENSE = GPLv2+
SUNXI_TOOLS_LICENSE_FILES = COPYING
HOST_SUNXI_TOOLS_DEPENDENCIES = host-libusb
FEX2BIN = $(HOST_DIR)/usr/bin/fex2bin

define HOST_SUNXI_TOOLS_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS) -std=c99 -D_POSIX_C_SOURCE=200112L -Iinclude/" \
		-C $(@D)
endef

define HOST_SUNXI_TOOLS_INSTALL_CMDS
	for i in fexc bin2fex fex2bin bootinfo fel pio; do \
		$(INSTALL) -D -m 0755 $(@D)/$$i $(HOST_DIR)/usr/bin/$$i ; \
	done
endef

define SUNXI_TOOLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -std=c99 -D_POSIX_C_SOURCE=200112L -Iinclude/" \
		-C $(@D) nand-part
endef

define SUNXI_TOOLS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/nand-part $(TARGET_DIR)/usr/bin/nand-part
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
