################################################################################
#
# elftosb
#
################################################################################

ELFTOSB_VERSION = 10.12.01
ELFTOSB_SITE = http://repository.timesys.com/buildsources/e/elftosb/elftosb-$(ELFTOSB_VERSION)
ELFTOSB_LICENSE = BSD-3-Clause
ELFTOSB_LICENSE_FILES = COPYING

define HOST_ELFTOSB_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) all
endef

define HOST_ELFTOSB_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bld/linux/elftosb $(HOST_DIR)/bin/elftosb
	$(INSTALL) -D -m 0755 $(@D)/bld/linux/keygen $(HOST_DIR)/bin/keygen
	$(INSTALL) -D -m 0755 $(@D)/bld/linux/sbtool $(HOST_DIR)/bin/sbtool
endef

$(eval $(host-generic-package))
