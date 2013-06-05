################################################################################
#
# b43-fwcutter
#
################################################################################

B43_FWCUTTER_VERSION = 015
B43_FWCUTTER_SITE = http://bues.ch/b43/fwcutter/
B43_FWCUTTER_SOURCE = b43-fwcutter-$(B43_FWCUTTER_VERSION).tar.bz2
B43_FWCUTTER_LICENSE = BSD-2c
B43_FWCUTTER_LICENSE_FILES = COPYING

define HOST_B43_FWCUTTER_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define HOST_B43_FWCUTTER_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/b43-fwcutter $(HOST_DIR)/usr/bin/b43-fwcutter
endef

$(eval $(host-generic-package))
