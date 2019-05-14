################################################################################
#
# streameye
#
################################################################################

STREAMEYE_VERSION = 6e4d9e3ad12ea8e5c0acef4d92f96bb0126ebcac
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

