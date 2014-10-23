################################################################################
#
# mii-diag
#
################################################################################

MII_DIAG_VERSION = 2.11
MII_DIAG_SOURCE = mii-diag_$(MII_DIAG_VERSION).orig.tar.gz
MII_DIAG_PATCH = mii-diag_$(MII_DIAG_VERSION)-3.diff.gz
MII_DIAG_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/m/mii-diag
MII_DIAG_LICENSE = GPL # No version specified
MII_DIAG_LICENSE_FILES = mii-diag.c

MII_DIAG_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS)

define MII_DIAG_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		$(APPLY_PATCHES) $(@D) $(@D)/debian/patches \*.patch; \
	fi
endef

MII_DIAG_POST_PATCH_HOOKS = MII_DIAG_DEBIAN_PATCHES

define MII_DIAG_BUILD_CMDS
	$(MAKE) $(MII_DIAG_MAKE_OPTS) -C $(@D) mii-diag
endef

define MII_DIAG_INSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install-mii-diag
endef

$(eval $(generic-package))
