################################################################################
#
# motion
#
################################################################################

MOTION_VERSION = 9fa9d22473899f654922174db0c474e14738a833
MOTION_SITE = $(call github,motion-project,motion,$(MOTION_VERSION))
MOTION_AUTORECONF = YES
MOTION_CONF_OPTS = --without-pgsql --without-sdl --without-sqlite3 --without-mysql --with-ffmpeg=$(STAGING_DIR)/usr/lib \
        --with-ffmpeg-headers=$(STAGING_DIR)/usr/include

define MOTION_INSTALL_TARGET_CMDS
    cp $(@D)/motion $(TARGET_DIR)/usr/bin/motion
endef

$(eval $(autotools-package))
