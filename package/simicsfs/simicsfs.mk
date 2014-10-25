################################################################################
#
# simicsfs
#
################################################################################

SIMICSFS_VERSION = 1.18
SIMICSFS_SITE = http://download.simics.net/pub
SIMICSFS_LICENSE = GPLv2+
SIMICSFS_LICENSE_FILES = hostfs.h
SIMICSFS_DEPENDENCIES = linux

define SIMICSFS_BUILD_CMDS
	$(MAKE) $(LINUX_MAKE_FLAGS) -C $(LINUX_DIR) M=$(@D) modules
endef

define SIMICSFS_INSTALL_TARGET_CMDS
	$(MAKE) $(LINUX_MAKE_FLAGS) -C $(LINUX_DIR) M=$(@D) INSTALL_MOD_PATH=$(TARGET_DIR) modules_install
endef

$(eval $(generic-package))
