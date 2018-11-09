################################################################################
#
# wf111
#
################################################################################

WF111_VERSION = 5-2-2-r3
WF111_SITE = https://www.silabs.com/documents/login/software
WF111_DEPENDENCIES = linux

ifeq ($(BR2_ARM_CPU_ARMV7A),y)
WF111_SOURCE = wf111-linux-driver-$(WF111_VERSION)-armv7-a.tar.gz
else ifeq ($(BR2_ARM_CPU_ARMV5),y)
WF111_SOURCE = wf111-linux-driver-$(WF111_VERSION)-armv5te.tar.gz
else ifeq ($(BR2_i386),y)
WF111_SOURCE = wf111-linux-driver-$(WF111_VERSION)-x86.tar.gz
endif

# Due to the stupidity of the package Makefile, we can't invoke
# separately the build step and the install step and get a correct
# behavior. So we do everything in the install step.
define WF111_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) PWD=$(@D) \
		$(LINUX_MAKE_FLAGS) KDIR=$(LINUX_DIR) \
		OUTPUT=$(TARGET_DIR) install_static
endef

$(eval $(generic-package))
