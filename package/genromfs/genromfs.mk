################################################################################
#
# genromfs
#
################################################################################

GENROMFS_VERSION = 0.5.2
GENROMFS_SITE = http://downloads.sourceforge.net/project/romfs/genromfs/$(GENROMFS_VERSION)
GENROMFS_LICENSE = GPL-2.0+
GENROMFS_LICENSE_FILES = COPYING

define GENROMFS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"
endef

# "PREFIX" is the equivalent of DESTDIR in autotools, "prefix" is the
# traditional prefix. "prefix" defaults to /usr so no need to set it.
define GENROMFS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) PREFIX=$(TARGET_DIR) install
endef

define HOST_GENROMFS_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_GENROMFS_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) prefix=$(HOST_DIR) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
