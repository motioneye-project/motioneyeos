################################################################################
#
# libsquish
#
################################################################################

LIBSQUISH_VERSION = 1.15
LIBSQUISH_SOURCE = libsquish-$(LIBSQUISH_VERSION).tgz
LIBSQUISH_SITE = http://downloads.sourceforge.net/project/libsquish
LIBSQUISH_INSTALL_STAGING = YES
LIBSQUISH_STRIP_COMPONENTS = 0
LIBSQUISH_LICENSE = MIT
LIBSQUISH_LICENSE_FILES = LICENSE.txt

define LIBSQUISH_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define LIBSQUISH_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include
	mkdir -p $(STAGING_DIR)/usr/lib
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		install PREFIX=/usr INSTALL_DIR=$(STAGING_DIR)/usr
	$(INSTALL) -D -m 644 $(@D)/libsquish.pc $(STAGING_DIR)/usr/lib/pkgconfig/libsquish.pc
	ln -sf libsquish.so.0.0 $(STAGING_DIR)/usr/lib/libsquish.so
	ln -sf libsquish.so.0.0 $(STAGING_DIR)/usr/lib/libsquish.so.0
endef

define LIBSQUISH_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/include
	mkdir -p $(TARGET_DIR)/usr/lib
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		install PREFIX=/usr INSTALL_DIR=$(TARGET_DIR)/usr
	ln -sf libsquish.so.0.0 $(TARGET_DIR)/usr/lib/libsquish.so.0
endef

$(eval $(generic-package))
