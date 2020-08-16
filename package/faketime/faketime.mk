################################################################################
#
# libfaketime
#
################################################################################

FAKETIME_VERSION = 0.9.8
FAKETIME_SITE = $(call github,wolfcw,libfaketime,v$(FAKETIME_VERSION))
FAKETIME_LICENSE = GPL-2.0
FAKETIME_LICENSE_FILES = COPYING

define HOST_FAKETIME_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) PREFIX=$(HOST_DIR)
endef

define HOST_FAKETIME_INSTALL_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) PREFIX=$(HOST_DIR) install
endef

$(eval $(host-generic-package))
