################################################################################
#
# ktap
#
################################################################################

KTAP_VERSION = eb66d40310c93dc82bc8eac889744c1ed1f01f7b
KTAP_SITE = $(call github,ktap,ktap,$(KTAP_VERSION))
KTAP_LICENSE = GPLv2
KTAP_LICENSE_FILES = LICENSE-GPL

ifeq ($(BR2_PACKAGE_ELFUTILS),y)
KTAP_DEPENDENCIES += elfutils
else
KTAP_FLAGS += NO_LIBELF=1
endif

define KTAP_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) $(KTAP_FLAGS) ktap
endef

define KTAP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m755 $(@D)/ktap  $(TARGET_DIR)/usr/bin/ktap
endef

KTAP_MODULE_MAKE_OPTS = KVERSION=$(LINUX_VERSION_PROBED)

$(eval $(kernel-module))
$(eval $(generic-package))
