#############################################################
#
# unionfs
#
#############################################################

UNIONFS_VERSION = 0.26
UNIONFS_SITE = http://podgorny.cz/unionfs-fuse/releases
UNIONFS_SOURCE = unionfs-fuse-$(UNIONFS_VERSION).tar.xz
UNIONFS_DEPENDENCIES = libfuse host-pkg-config
UNIONFS_LICENSE = BSD-3c
UNIONFS_LICENSE_FILES = LICENSE

define UNIONFS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define UNIONFS_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) PREFIX=/usr DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
