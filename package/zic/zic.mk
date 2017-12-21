################################################################################
#
# zic
#
################################################################################

ZIC_VERSION = 2017c
ZIC_SOURCE = tzcode$(ZIC_VERSION).tar.gz
ZIC_SITE = http://www.iana.org/time-zones/repository/releases
ZIC_STRIP_COMPONENTS = 0
ZIC_LICENSE = Public domain

define HOST_ZIC_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) zic
endef

define HOST_ZIC_INSTALL_CMDS
	$(INSTALL) -D -m 755 $(@D)/zic $(HOST_DIR)/sbin/zic
	$(INSTALL) -D -m 644 $(@D)/tzfile.h $(HOST_DIR)/include/tzfile.h
endef

$(eval $(host-generic-package))

ZIC = $(HOST_DIR)/sbin/zic
