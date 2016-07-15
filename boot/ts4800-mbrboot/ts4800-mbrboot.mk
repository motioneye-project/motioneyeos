################################################################################
#
# ts4800-mbrboot
#
################################################################################

TS4800_MBRBOOT_VERSION = cf8f7072ed5a4a4e48fcb9841b2e31e519ec5dca
TS4800_MBRBOOT_SITE = $(call github,embeddedarm,ts4800-mbrboot,$(TS4800_MBRBOOT_VERSION))
TS4800_MBRBOOT_LICENSE = BSD-2c
TS4800_MBRBOOT_LICENSE_FILES = LICENSE
TS4800_MBRBOOT_INSTALL_IMAGES = YES

define TS4800_MBRBOOT_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define TS4800_MBRBOOT_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(@D)/mbrboot.bin $(BINARIES_DIR)/mbrboot.bin
endef

$(eval $(generic-package))
