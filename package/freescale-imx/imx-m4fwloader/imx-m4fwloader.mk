################################################################################
#
# imx-m4fwloader
#
################################################################################

IMX_M4FWLOADER_VERSION = 8cf4d17a09ba23250d43381b49ba00d92406fad9
IMX_M4FWLOADER_SITE = $(call github,codeauroraforum,imx-m4fwloader,$(IMX_M4FWLOADER_VERSION))
IMX_M4FWLOADER_LICENSE = GPL-2.0+
IMX_M4FWLOADER_LICENSE_FILES = LICENSE

define IMX_M4FWLOADER_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) -o $(@D)/imx-m4fwloader \
		$(@D)/m4fwloader.c
endef

define IMX_M4FWLOADER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/imx-m4fwloader \
		$(TARGET_DIR)/usr/sbin/imx-m4fwloader
endef

$(eval $(generic-package))
