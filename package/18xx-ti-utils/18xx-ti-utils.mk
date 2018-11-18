################################################################################
#
# 18xx-ti-utils
#
################################################################################

18XX_TI_UTILS_VERSION = R8.7_SP3
18XX_TI_UTILS_SITE = git://git.ti.com/wilink8-wlan/18xx-ti-utils
18XX_TI_UTILS_DEPENDENCIES = libnl
18XX_TI_UTILS_LICENSE = BSD-3-Clause
18XX_TI_UTILS_LICENSE_FILES = COPYING

18XX_TI_UTILS_CFLAGS = -I$(STAGING_DIR)/usr/include/libnl3 -DCONFIG_LIBNL32

ifeq ($(BR2_STATIC_LIBS),y)
18XX_TI_UTILS_BUILD_TARGET = static
endif

define 18XX_TI_UTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) CROSS_COMPILE=$(TARGET_CROSS) \
		NFSROOT="$(STAGING_DIR)" NLVER=3 $(MAKE) -C $(@D) \
		CFLAGS="$(TARGET_CFLAGS) $(18XX_TI_UTILS_CFLAGS)" \
		$(18XX_TI_UTILS_BUILD_TARGET)
endef

define 18XX_TI_UTILS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/calibrator $(TARGET_DIR)/usr/bin/calibrator
endef

$(eval $(generic-package))
