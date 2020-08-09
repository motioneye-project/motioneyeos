################################################################################
#
# imx-uuc
#
################################################################################

IMX_UUC_VERSION = fc48b497fe961d601b4bcced807f562090854ec9
IMX_UUC_SITE = $(call github,NXPmicro,imx-uuc,$(IMX_UUC_VERSION))
IMX_UUC_LICENSE = GPL-2.0+
IMX_UUC_LICENSE_FILES = COPYING

# mkfs.vfat is needed to create a FAT partition used by g_mass_storage
# so Windows do not offer to format the device when connected to the PC.
IMX_UUC_DEPENDENCIES = host-dosfstools

define IMX_UUC_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define IMX_UUC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/uuc $(TARGET_DIR)/usr/bin/uuc
	$(INSTALL) -D -m 755 $(@D)/sdimage $(TARGET_DIR)/usr/bin/sdimage
	$(INSTALL) -D -m 755 $(@D)/ufb $(TARGET_DIR)/usr/bin/ufb
	dd if=/dev/zero of=$(TARGET_DIR)/fat bs=1M count=1
	$(HOST_DIR)/sbin/mkfs.vfat $(TARGET_DIR)/fat
endef

define IMX_UUC_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/freescale-imx/imx-uuc/S80imx-uuc \
		$(TARGET_DIR)/etc/init.d/S80imx-uuc
endef

define IMX_UUC_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/freescale-imx/imx-uuc/imx-uuc.service \
		$(TARGET_DIR)/usr/lib/systemd/system/imx-uuc.service
endef

$(eval $(generic-package))
