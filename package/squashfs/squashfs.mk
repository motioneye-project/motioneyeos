SQUASHFS_VERSION=4.0
SQUASHFS_SOURCE=squashfs$(SQUASHFS_VERSION).tar.gz
SQUASHFS_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/squashfs

SQUASHFS_DEPENDENCIES = zlib
HOST_SQUASHFS_DEPENDENCIES = host-zlib

define SQUASHFS_BUILD_CMDS
 $(TARGET_MAKE_ENV) $(MAKE)    \
   CC="$(TARGET_CC)"           \
   CFLAGS="$(TARGET_CFLAGS)"   \
   LDFLAGS="$(TARGET_LDFLAGS)" \
   -C $(@D)/squashfs-tools/
endef

define SQUASHFS_INSTALL_TARGET_CMDS
 $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/squashfs-tools/ INSTALL_DIR=$(TARGET_DIR)/usr/bin install
endef

define HOST_SQUASHFS_BUILD_CMDS
 $(HOST_MAKE_ENV) $(MAKE) CFLAGS="$(HOST_CFLAGS)" LDFLAGS="$(HOST_LDFLAGS)" -C $(@D)/squashfs-tools/
endef

define HOST_SQUASHFS_INSTALL_CMDS
 $(HOST_MAKE_ENV) $(MAKE) -C $(@D)/squashfs-tools/ INSTALL_DIR=$(HOST_DIR)/usr/bin install
endef

$(eval $(call GENTARGETS,package,squashfs))
$(eval $(call GENTARGETS,package,squashfs,host))

