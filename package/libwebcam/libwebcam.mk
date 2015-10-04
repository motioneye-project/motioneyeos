################################################################################
#
# libwebcam
#
################################################################################

LIBWEBCAM_VERSION = 0.2.5
LIBWEBCAM_SOURCE = libwebcam-src-$(LIBWEBCAM_VERSION).tar.gz
LIBWEBCAM_SITE = http://freefr.dl.sourceforge.net/project/libwebcam/source/
LIBWEBCAM_DEPENDENCIES = libxml2

define LIBWEBCAM_INSTALL_TARGET_CMDS
    rm $(@D)/uvcdynctrl/uvcdynctrl-*.gz
    cp $(@D)/uvcdynctrl/uvcdynctrl $(TARGET_DIR)/usr/bin/uvcdynctrl
    cp -d $(@D)/libwebcam/libwebcam.so* $(TARGET_DIR)/usr/lib
endef

$(eval $(cmake-package))

