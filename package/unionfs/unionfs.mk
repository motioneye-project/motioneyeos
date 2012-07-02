#############################################################
#
# unionfs
#
#############################################################

UNIONFS_VERSION = 0.25
UNIONFS_SITE = http://podgorny.cz/unionfs-fuse/releases
UNIONFS_SOURCE = unionfs-fuse-$(UNIONFS_VERSION).tar.bz2
UNIONFS_DEPENDENCIES = libfuse

define UNIONFS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define UNIONFS_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) PREFIX=/usr DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
