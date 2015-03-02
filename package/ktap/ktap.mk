################################################################################
#
# ktap
#
################################################################################

KTAP_VERSION = eb66d40310c93dc82bc8eac889744c1ed1f01f7b
KTAP_SITE = $(call github,ktap,ktap,$(KTAP_VERSION))
KTAP_LICENSE = GPLv2
KTAP_LICENSE_FILES = LICENSE-GPL

KTAP_DEPENDENCIES = linux

ifeq ($(BR2_PACKAGE_ELFUTILS),y)
KTAP_DEPENDENCIES += elfutils
else
KTAP_FLAGS += NO_LIBELF=1
endif

define KTAP_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) $(KTAP_FLAGS) ktap
	$(MAKE) -C $(@D) $(LINUX_MAKE_FLAGS) KERNEL_SRC=$(LINUX_DIR) KVERSION=$(LINUX_VERSION_PROBED) mod
endef

define KTAP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m755 $(@D)/ktap  $(TARGET_DIR)/usr/bin/ktap
	$(MAKE) -C $(@D) $(LINUX_MAKE_FLAGS) KERNEL_SRC=$(LINUX_DIR) KVERSION=$(LINUX_VERSION_PROBED) modules_install
endef

$(eval $(generic-package))
