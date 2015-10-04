################################################################################
#
# iprutils
#
################################################################################

IPRUTILS_VERSION = 2.4.5
IPRUTILS_SITE = http://downloads.sourceforge.net/project/iprdd/iprutils%20for%202.6%20kernels/$(IPRUTILS_VERSION)
IPRUTILS_SOURCE = iprutils-$(IPRUTILS_VERSION)-src.tgz
IPRUTILS_DEPENDENCIES = ncurses libsysfs pciutils
IPRUTILS_LICENSE = Common Public License Version 1.0
IPRUTILS_LICENSE_FILES = LICENSE

define IPRUTILS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		INCLUDEDIR="-I." all
endef

define IPRUTILS_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) INSTALL_MOD_PATH=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
