################################################################################
#
# motion
#
################################################################################

MOTION_VERSION = e9e0a2d29205956055dd5ba7ca0cb52b585f182a
MOTION_SITE = $(call github,motion-project,motion,$(MOTION_VERSION))
MOTION_AUTORECONF = YES
MOTION_CONF_OPTS = --without-pgsql --without-sdl --without-sqlite3 --without-mysql --with-ffmpeg=$(STAGING_DIR)/usr/lib \
        --with-ffmpeg-headers=$(STAGING_DIR)/usr/include

define MOTION_INSTALL_TARGET_CMDS
    cp $(@D)/motion $(TARGET_DIR)/usr/bin/motion
endef

$(eval $(autotools-package))
