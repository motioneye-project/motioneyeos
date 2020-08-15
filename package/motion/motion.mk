################################################################################
#
# motion
#
################################################################################

MOTION_VERSION = release-4.3.1
MOTION_SITE = $(call github,Motion-Project,motion,$(MOTION_VERSION))
MOTION_LICENSE = GPL-2.0
MOTION_LICENSE_FILES = doc/COPYING
MOTION_AUTORECONF = YES
MOTION_DEPENDENCIES = host-pkgconf ffmpeg jpeg libmicrohttpd
MOTION_CONF_OPTS = --without-pgsql \
                   --without-sqlite3 \
                   --without-mysql \
                   --without-mariadb \
                   --with-ffmpeg=$(STAGING_DIR)/usr/lib

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
MOTION_DEPENDENCIES += rpi-userland
endif

define MOTION_INSTALL_TARGET_CMDS
    cp $(@D)/src/motion $(TARGET_DIR)/usr/bin/motion
endef

define MOTION_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/motion/motion.service \
		$(TARGET_DIR)/usr/lib/systemd/system/motion.service
endef

$(eval $(autotools-package))
