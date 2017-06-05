################################################################################
#
# libhdhomerun
#
################################################################################

LIBHDHOMERUN_VERSION = 20161117
LIBHDHOMERUN_SOURCE = libhdhomerun_$(LIBHDHOMERUN_VERSION).tgz
LIBHDHOMERUN_SITE = http://download.silicondust.com/hdhomerun
LIBHDHOMERUN_LICENSE = LGPL-2.1+
LIBHDHOMERUN_LICENSE_FILES = LICENSE
LIBHDHOMERUN_INSTALL_STAGING = YES

define LIBHDHOMERUN_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) \
		CROSS_COMPILE="$(TARGET_CROSS)" -C $(@D)
endef

define LIBHDHOMERUN_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libhdhomerun.so \
		$(STAGING_DIR)/usr/lib/libhdhomerun.so
	mkdir -p $(STAGING_DIR)/usr/include/libhdhomerun/
	$(INSTALL) -m 0644 $(@D)/*.h \
		$(STAGING_DIR)/usr/include/libhdhomerun/
endef

define LIBHDHOMERUN_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libhdhomerun.so \
		$(TARGET_DIR)/usr/lib/libhdhomerun.so
endef

$(eval $(generic-package))
