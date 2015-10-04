################################################################################
#
# motion-mrdave
#
################################################################################

MOTION_MRDAVE_VERSION = 5c6f4be
MOTION_MRDAVE_SITE = $(call github,mr-dave,motion,$(MOTION_MRDAVE_VERSION))
MOTION_MRDAVE_CONF_OPTS = --without-pgsql --without-sdl --without-sqlite3 --without-mysql --with-ffmpeg=$(STAGING_DIR)/usr/lib \
        --with-ffmpeg-headers=$(STAGING_DIR)/usr/include                                     

define MOTION_MRDAVE_INSTALL_TARGET_CMDS
    cp $(@D)/motion $(TARGET_DIR)/usr/bin/motion-mrdave
endef

$(eval $(autotools-package))

