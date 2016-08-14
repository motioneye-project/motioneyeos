################################################################################
#
# wf111
#
################################################################################

WF111_VERSION = 5.2.2-r2
WF111_SITE_METHOD = file
WF111_SITE = $(call qstrip,$(BR2_PACKAGE_WF111_TARBALL_PATH))
WF111_DEPENDENCIES = linux

ifeq ($(BR2_PACKAGE_WF111)$(call qstrip,$(BR2_PACKAGE_WF111_TARBALL_PATH)),y)
$(error No tarball location specified, check BR2_PACKAGE_WF111_TARBALL_PATH)
endif

ifeq ($(BR2_ARM_CPU_ARMV7A),y)
WF111_SOURCE = wf111-linux-driver_$(WF111_VERSION)_armv7-a.tar.gz
else ifeq ($(BR2_ARM_CPU_ARMV5),y)
WF111_SOURCE = wf111-linux-driver_$(WF111_VERSION)_armv5t.tar.gz
else ifeq ($(BR2_i386),y)
WF111_SOURCE = wf111-linux-driver_$(WF111_VERSION)_x86.tar.gz
endif

# Due to the stupidity of the package Makefile, we can't invoke
# separately the build step and the install step and get a correct
# behavior. So we do everything in the install step.
define WF111_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) PWD=$(@D) \
		$(LINUX_MAKE_FLAGS) KDIR=$(LINUX_DIR) \
		OUTPUT=$(TARGET_DIR) install_static
endef

$(eval $(generic-package))
