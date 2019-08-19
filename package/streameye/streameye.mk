################################################################################
#
# streameye
#
################################################################################

STREAMEYE_VERSION = 502a63bb14f8105a3daa9f0940b237300fe76d6f
STREAMEYE_SITE = $(call github,ccrisan,streameye,$(STREAMEYE_VERSION))
STREAMEYE_LICENSE = GPLv3

define STREAMEYE_BUILD_CMDS
    make CC="$(TARGET_CC)" -C "$(@D)"
endef

define STREAMEYE_INSTALL_TARGET_CMDS
    cp $(@D)/streameye $(TARGET_DIR)/usr/bin/
    cp $(@D)/extras/raspimjpeg.py $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))

