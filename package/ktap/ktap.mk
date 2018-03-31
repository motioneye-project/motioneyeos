################################################################################
#
# ktap
#
################################################################################

KTAP_VERSION = 23bc7a4a94bd9e4e1b8b7c06632e61c041d57b5f
KTAP_SITE = $(call github,ktap,ktap,$(KTAP_VERSION))
KTAP_LICENSE = GPL-2.0
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
