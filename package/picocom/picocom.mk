################################################################################
#
# picocom
#
################################################################################

PICOCOM_VERSION = 3.0
PICOCOM_SITE = $(call github,npat-efault,picocom,$(PICOCOM_VERSION))
PICOCOM_LICENSE = GPL-2.0+
PICOCOM_LICENSE_FILES = LICENSE.txt

define PICOCOM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define PICOCOM_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/picocom $(TARGET_DIR)/usr/bin/picocom
endef

$(eval $(generic-package))
