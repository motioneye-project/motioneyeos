################################################################################
#
# motion
#
################################################################################

MOTION_VERSION = release-4.1.1
MOTION_SITE = $(call github,motion-project,motion,$(MOTION_VERSION))
MOTION_AUTORECONF = YES
MOTION_CONF_OPTS = --without-pgsql \
                   --without-sdl \
                   --without-sqlite3 \
                   --without-mysql \
                   --with-ffmpeg=$(STAGING_DIR)/usr/lib \
                   --with-ffmpeg-headers=$(STAGING_DIR)/usr/include

define MOTION_INSTALL_TARGET_CMDS
    cp $(@D)/motion $(TARGET_DIR)/usr/bin/motion
endef

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
MOTION_DEPENDENCIES += rpi-userland
MOTION_CONF_OPTS += \
        --with-mmal-include=$(STAGING_DIR)/usr/include \
        --with-mmal-lib=$(STAGING_DIR)/lib
endif

$(eval $(autotools-package))

