################################################################################
#
# owl-linux
#
################################################################################

OWL_LINUX_VERSION = 1.0.7
OWL_LINUX_SITE = http://linux.hd-wireless.se/pub/Linux/DownloadDrivers
OWL_LINUX_LICENSE = PROPRIETARY
OWL_LINUX_LICENSE_FILES = LICENSE
OWL_LINUX_REDISTRIBUTE = NO

OWL_LINUX_DEPENDENCIES = linux

define OWL_LINUX_BUILD_CMDS
	$(MAKE) -C $(@D) $(LINUX_MAKE_FLAGS) KERNELDIR=$(LINUX_DIR)
endef

define OWL_LINUX_INSTALL_TARGET_CMDS
	$(MAKE) -C $(LINUX_DIR) $(LINUX_MAKE_FLAGS) M="$(@D)" modules_install
endef

$(eval $(generic-package))
