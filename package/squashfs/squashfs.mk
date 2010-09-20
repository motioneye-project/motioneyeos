SQUASHFS_VERSION=4.1
SQUASHFS_SOURCE=squashfs$(SQUASHFS_VERSION).tar.gz
SQUASHFS_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/squashfs

# no libattr/xz in BR
SQUASHFS_MAKE_ARGS = XATTR_SUPPORT=0 XZ_SUPPORT=0

# we need atleast one compresser, so use gzip if lzo isn't enabled
ifeq ($(BR2_PACKAGE_SQUASHFS_GZIP)$(if $(BR2_PACKAGE_SQUASHFS_LZO),,y),y)
SQUASHFS_DEPENDENCIES += zlib
SQUASHFS_MAKE_ARGS += GZIP_SUPPORT=1
else
SQUASHFS_MAKE_ARGS += GZIP_SUPPORT=0 COMP_DEFAULT=lzo
endif

ifeq ($(BR2_PACKAGE_SQUASHFS_LZO),y)
SQUASHFS_DEPENDENCIES += lzo
SQUASHFS_MAKE_ARGS += LZO_SUPPORT=1
else
SQUASHFS_MAKE_ARGS += LZO_SUPPORT=0
endif


HOST_SQUASHFS_DEPENDENCIES = host-zlib host-lzo

# no libattr/xz in BR
HOST_SQUASHFS_MAKE_ARGS = \
	XATTR_SUPPORT=0 \
	XZ_SUPPORT=0    \
	GZIP_SUPPORT=1  \
	LZO_SUPPORT=1

define SQUASHFS_BUILD_CMDS
 $(TARGET_MAKE_ENV) $(MAKE)    \
   CC="$(TARGET_CC)"           \
   EXTRA_CFLAGS="$(TARGET_CFLAGS)"   \
   EXTRA_LDFLAGS="$(TARGET_LDFLAGS)" \
   $(SQUASHFS_MAKE_ARGS) \
   -C $(@D)/squashfs-tools/
endef

define SQUASHFS_INSTALL_TARGET_CMDS
 $(TARGET_MAKE_ENV) $(MAKE) $(SQUASHFS_MAKE_ARGS) \
   -C $(@D)/squashfs-tools/ INSTALL_DIR=$(TARGET_DIR)/usr/bin install
endef

define HOST_SQUASHFS_BUILD_CMDS
 $(HOST_MAKE_ENV) $(MAKE) \
   CC="$(HOSTCC)" \
   EXTRA_CFLAGS="$(HOST_CFLAGS)"   \
   EXTRA_LDFLAGS="$(HOST_LDFLAGS)" \
   $(HOST_SQUASHFS_MAKE_ARGS) \
   -C $(@D)/squashfs-tools/
endef

define HOST_SQUASHFS_INSTALL_CMDS
 $(HOST_MAKE_ENV) $(MAKE) $(HOST_SQUASHFS_MAKE_ARGS) \
   -C $(@D)/squashfs-tools/ INSTALL_DIR=$(HOST_DIR)/usr/bin install
endef

$(eval $(call GENTARGETS,package,squashfs))
$(eval $(call GENTARGETS,package,squashfs,host))
