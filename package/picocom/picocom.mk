################################################################################
#
# picocom
#
################################################################################

PICOCOM_VERSION = 2.0
PICOCOM_SITE = $(call github,npat-efault,picocom,$(PICOCOM_VERSION))
PICOCOM_LICENSE = GPLv2+
PICOCOM_LICENSE_FILES = LICENSE.txt
PICOCOM_PATCH = https://github.com/npat-efault/picocom/commit/2c4c2317592daac97aac6669fd7b68e07a3dbec6.patch

define PICOCOM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define PICOCOM_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/picocom $(TARGET_DIR)/usr/bin/picocom
endef

$(eval $(generic-package))
