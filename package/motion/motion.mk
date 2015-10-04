################################################################################
#
# motion
#
################################################################################

MOTION_SITE = http://www.lavrsen.dk/svn/motion/trunk/
MOTION_SITE_METHOD = svn
MOTION_VERSION = r561
MOTION_CONF_OPTS = --without-pgsql --without-sdl --without-sqlite3 --without-mysql --with-ffmpeg=$(STAGING_DIR)/usr/lib \
        --with-ffmpeg-headers=$(STAGING_DIR)/usr/include

define MOTION_INSTALL_TARGET_CMDS
    cp $(@D)/motion $(TARGET_DIR)/usr/bin/motion-svn
endef

$(eval $(autotools-package))
