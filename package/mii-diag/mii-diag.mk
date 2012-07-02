#############################################################
#
# mii-diag
#
#############################################################
MII_DIAG_VERSION = 2.11
MII_DIAG_SOURCE  = mii-diag_$(MII_DIAG_VERSION).orig.tar.gz
MII_DIAG_PATCH   = mii-diag_$(MII_DIAG_VERSION)-3.diff.gz
MII_DIAG_SITE    = $(BR2_DEBIAN_MIRROR)/debian/pool/main/m/mii-diag

MII_DIAG_MAKE_OPT = $(TARGET_CONFIGURE_OPTS)

define MII_DIAG_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		support/scripts/apply-patches.sh $(@D) $(@D)/debian/patches \*.patch; \
	fi
endef

MII_DIAG_POST_PATCH_HOOKS = MII_DIAG_DEBIAN_PATCHES

define MII_DIAG_BUILD_CMDS
	$(MAKE) $(MII_DIAG_MAKE_OPT) -C $(@D)
endef

define MII_DIAG_INSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

define MII_DIAG_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/mii-diag
endef

define MII_DIAG_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
