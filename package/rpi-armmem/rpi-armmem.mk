################################################################################
#
# rpi-armmem
#
################################################################################

RPI_ARMMEM_VERSION = 3aee5f40c201b9fd50d6f79b8db89f4343820f2c
RPI_ARMMEM_SITE = $(call github,bavison,arm-mem,$(RPI_ARMMEM_VERSION))
CFLAGS = -fPIC -std=gnu99 -O2

define RPI_ARMMEM_BUILD_CMDS
	$(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" CFLAGS="$(CFLAGS)" libarmmem.so -C $(@D)
endef

define RPI_ARMMEM_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libarmmem.so $(TARGET_DIR)/usr/lib/libarmmem.so
endef

$(eval $(generic-package))

