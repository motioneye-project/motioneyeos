################################################################################
#
# msr-tools
#
################################################################################

MSR_TOOLS_VERSION = 1.3
MSR_TOOLS_SITE = $(call github,01org,msr-tools,msr-tools-$(MSR_TOOLS_VERSION))
MSR_TOOLS_LICENSE = GPL-2.0
MSR_TOOLS_LICENSE_FILES = cpuid.c

define MSR_TOOLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define MSR_TOOLS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) install \
		sbindir="$(TARGET_DIR)/usr/sbin"
endef

$(eval $(generic-package))
