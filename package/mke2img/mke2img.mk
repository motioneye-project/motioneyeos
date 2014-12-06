################################################################################
#
# mke2img
#
################################################################################

HOST_MKE2IMG_SOURCE =
HOST_MKE2IMG_DEPENDENCIES = host-genext2fs host-e2fsprogs

define HOST_MKE2IMG_INSTALL_CMDS
	$(INSTALL) -D -m 0755 package/mke2img/mke2img $(HOST_DIR)/usr/bin/mke2img
endef

$(eval $(host-generic-package))
