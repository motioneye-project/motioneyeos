################################################################################
#
# on2-8170-modules
#
################################################################################

ON2_8170_MODULES_VERSION = 73b08061d30789178e692bc332b73d1d9922bf39
ON2_8170_MODULES_SITE = $(call github,alexandrebelloni,on2-8170-modules,$(ON2_8170_MODULES_VERSION))

ON2_8170_MODULES_DEPENDENCIES = linux

ON2_8170_MODULES_LICENSE = GPLv2+
#There is no license file

define ON2_8170_MODULES_BUILD_CMDS
	$(MAKE) -C $(LINUX_DIR) $(LINUX_MAKE_FLAGS) M=$(@D)
endef

define ON2_8170_MODULES_INSTALL_TARGET_CMDS
	$(MAKE) -C $(LINUX_DIR) $(LINUX_MAKE_FLAGS) M=$(@D) modules_install
endef

$(eval $(generic-package))
