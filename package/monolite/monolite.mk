################################################################################
#
# monolite
#
################################################################################

MONOLITE_VERSION = 117
MONOLITE_SITE = http://storage.bos.xamarin.com/mono-dist-master/latest
MONOLITE_SOURCE = monolite-$(MONOLITE_VERSION)-latest.tar.gz
MONOLITE_LICENSE = LGPLv2 or commercial

define HOST_MONOLITE_INSTALL_CMDS
	mkdir -p $(HOST_DIR)/usr/lib/monolite
	cp $(@D)/* $(HOST_DIR)/usr/lib/monolite
endef

$(eval $(host-generic-package))
