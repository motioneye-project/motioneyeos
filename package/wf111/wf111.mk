################################################################################
#
# wf111
#
################################################################################

WF111_VERSION = 5.2.2
WF111_SITE_METHOD = file
WF111_SITE = $(call qstrip,$(BR2_PACKAGE_WF111_TARBALL_PATH))
WF111_DEPENDENCIES = linux

ifeq ($(BR2_PACKAGE_WF111)$(call qstrip,$(BR2_PACKAGE_WF111_TARBALL_PATH)),y)
$(error No tarball location specified, check BR2_PACKAGE_WF111_TARBALL_PATH)
endif

ifeq ($(BR2_ARM_CPU_ARMV7A),y)
WF111_SOURCE = wf111-linux-driver_5.2.2-r1_armv7-a.tar.gz
else ifeq ($(BR2_ARM_CPU_ARMV5),y)
WF111_SOURCE = wf111-linux-driver_5.2.2-r1_armv5t.tar.gz
else ifeq ($(BR2_i386),y)
WF111_SOURCE = wf111-linux-driver_5.2.2-r1_x86.tar.gz
endif

define WF111_BUILD_CMDS
	$(MAKE) -C $(@D) PWD=$(@D) \
		$(LINUX_MAKE_FLAGS) KDIR=$(LINUX_DIR) \
		install_static
endef

define WF111_INSTALL_TARGET_CMDS
	cp -dpfr $(@D)/output/* $(TARGET_DIR)
endef

$(eval $(generic-package))
