################################################################################
#
# monolite
#
################################################################################

MONOLITE_VERSION = 149
MONOLITE_SITE = http://download.mono-project.com/monolite/
MONOLITE_SOURCE = monolite-$(MONOLITE_VERSION)-latest.tar.gz
MONOLITE_LICENSE = LGPLv2 or commercial

define HOST_MONOLITE_INSTALL_CMDS
	mkdir -p $(HOST_DIR)/usr/lib/monolite
	cp $(@D)/* $(HOST_DIR)/usr/lib/monolite
endef

$(eval $(host-generic-package))
