################################################################################
#
# streameye
#
################################################################################

STREAMEYE_VERSION = ffd6f28a094f70c70893f6e516610459faa15ea2
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

