################################################################################
#
# streameye
#
################################################################################

STREAMEYE_VERSION = bdfec2170d23906fd96d3755c7beb10ea562b861
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

