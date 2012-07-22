#############################################################
#
# elftosb
#
#############################################################
ELFTOSB_VERSION = 10.12.01
ELFTOSB_SOURCE = elftosb-$(ELFTOSB_VERSION).tar.gz
ELFTOSB_SITE = http://repository.timesys.com/buildsources/e/elftosb/elftosb-$(ELFTOSB_VERSION)

define HOST_ELFTOSB_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) all
endef

define HOST_ELFTOSB_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bld/linux/elftosb $(HOST_DIR)/usr/bin/elftosb
	$(INSTALL) -D -m 0755 $(@D)/bld/linux/keygen $(HOST_DIR)/usr/bin/keygen
	$(INSTALL) -D -m 0755 $(@D)/bld/linux/sbtool $(HOST_DIR)/usr/bin/sbtool
endef

define HOST_ELFTOSB_CLEAN_CMDS
	rm -rf $(@D)/bld/linux
endef

$(eval $(host-generic-package))

