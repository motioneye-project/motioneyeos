SQUASHFS3_VERSION=3.4
SQUASHFS3_SOURCE=squashfs$(SQUASHFS3_VERSION).tar.gz
SQUASHFS3_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/squashfs

SQUASHFS3_DEPENDENCIES = zlib
HOST_SQUASHFS3_DEPENDENCIES = host-zlib

define SQUASHFS3_BUILD_CMDS
 $(TARGET_MAKE_ENV) $(MAKE)    \
   CC="$(TARGET_CC)"           \
   CFLAGS="$(TARGET_CFLAGS)"   \
   LDFLAGS="$(TARGET_LDFLAGS)" \
   -C $(@D)/squashfs-tools/
endef

define SQUASHFS3_INSTALL_TARGET_CMDS
 $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/squashfs-tools/ INSTALL_DIR=$(TARGET_DIR)/usr/bin install
endef

define HOST_SQUASHFS3_BUILD_CMDS
 $(HOST_MAKE_ENV) $(MAKE) CFLAGS="$(HOST_CFLAGS)" LDFLAGS="$(HOST_LDFLAGS)" -C $(@D)/squashfs-tools/
endef

define HOST_SQUASHFS3_INSTALL_CMDS
 $(HOST_MAKE_ENV) $(MAKE) -C $(@D)/squashfs-tools/ INSTALL_DIR=$(HOST_DIR)/usr/bin install
endef

$(eval $(call GENTARGETS,package,squashfs3))
$(eval $(call GENTARGETS,package,squashfs3,host))

