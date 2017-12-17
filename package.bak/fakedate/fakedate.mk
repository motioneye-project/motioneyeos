################################################################################
#
# fakedate
#
################################################################################

# source included in buildroot
HOST_FAKEDATE_LICENSE = GPLv2+

define HOST_FAKEDATE_INSTALL_CMDS
	$(INSTALL) -D -m 755 package/fakedate/fakedate $(HOST_DIR)/usr/bin/fakedate
	ln -sfn fakedate $(HOST_DIR)/usr/bin/date
endef

$(eval $(host-generic-package))
