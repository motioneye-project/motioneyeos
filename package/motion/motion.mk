################################################################################
#
# motion
#
################################################################################

MOTION_VERSION = release-4.2
MOTION_SITE = $(call github,Motion-Project,motion,$(MOTION_VERSION))
MOTION_LICENSE = GPL-2.0
MOTION_LICENSE_FILES = COPYING
MOTION_DEPENDENCIES = host-pkgconf jpeg libmicrohttpd $(TARGET_NLS_DEPENDENCIES)
# From git
MOTION_AUTORECONF = YES

MOTION_CONF_OPTS += --without-optimizecpu

ifeq ($(BR2_PACKAGE_FFMPEG_SWSCALE),y)
MOTION_DEPENDENCIES += ffmpeg
MOTION_CONF_OPTS += --with-ffmpeg
else
MOTION_CONF_OPTS += --without-ffmpeg
endif

ifeq ($(BR2_PACKAGE_MYSQL),y)
MOTION_DEPENDENCIES += mysql
MOTION_CONF_OPTS += \
	--with-mysql \
	--with-mysql-include=$(STAGING_DIR)/usr/include/mysql \
	--with-mysql-lib=$(STAGING_DIR)/usr/lib
else
MOTION_CONF_OPTS += --without-mysql
endif

ifeq ($(BR2_PACKAGE_POSTGRESQL),y)
MOTION_DEPENDENCIES += postgresql
MOTION_CONF_OPTS += \
	--with-pgsql \
	--with-pgsql-include=$(STAGING_DIR)/usr/include \
	--with-pgsql-lib=$(STAGING_DIR)/usr/lib
else
MOTION_CONF_OPTS += --without-pgsql
endif

ifeq ($(BR2_PACKAGE_SQLITE),y)
MOTION_DEPENDENCIES += sqlite
MOTION_CONF_OPTS += --with-sqlite3
else
MOTION_CONF_OPTS += --without-sqlite3
endif

ifeq ($(BR2_PACKAGE_WEBP_MUX),y)
MOTION_DEPENDENCIES += webp
MOTION_CONF_OPTS += --with-webp
else
MOTION_CONF_OPTS += --without-webp
endif

# Do not use default install target as it installs many unneeded files and
# directories: docs, examples and init scripts
define MOTION_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/motion-dist.conf \
		$(TARGET_DIR)/etc/motion/motion.conf
	$(INSTALL) -D -m 0755 $(@D)/motion $(TARGET_DIR)/usr/bin/motion
endef

define MOTION_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/motion/S99motion \
		$(TARGET_DIR)/etc/init.d/S99motion
endef

define MOTION_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/motion/motion.service \
		$(TARGET_DIR)/usr/lib/systemd/system/motion.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/motion.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/motion.service
endef

$(eval $(autotools-package))
