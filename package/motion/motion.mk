################################################################################
#
# motion
#
################################################################################

MOTION_VERSION = 8f18946261ebee45a33ce423c9154b0f94997b51
MOTION_SITE = $(call github,Motion-Project,motion,$(MOTION_VERSION))
MOTION_AUTORECONF = YES
MOTION_DEPENDENCIES = host-pkgconf ffmpeg jpeg libmicrohttpd
MOTION_CONF_OPTS = --without-pgsql \
                   --without-sqlite3 \
                   --without-mysql \
                   --without-mariadb \
                   --with-ffmpeg=$(STAGING_DIR)/usr/lib

define MOTION_INSTALL_TARGET_CMDS
    cp $(@D)/src/motion $(TARGET_DIR)/usr/bin/motion
endef

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
MOTION_DEPENDENCIES += rpi-userland
endif

$(eval $(autotools-package))

