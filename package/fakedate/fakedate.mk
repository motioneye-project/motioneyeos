################################################################################
#
# fakedate
#
################################################################################

# source included in buildroot
HOST_FAKEDATE_LICENSE = GPL-2.0+

define HOST_FAKEDATE_INSTALL_CMDS
	$(INSTALL) -D -m 755 package/fakedate/fakedate $(HOST_DIR)/bin/date
endef

$(eval $(host-generic-package))
