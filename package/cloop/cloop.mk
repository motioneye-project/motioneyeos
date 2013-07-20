################################################################################
#
# cloop
#
################################################################################

CLOOP_VERSION = 2.634-1
CLOOP_SOURCE = cloop_$(CLOOP_VERSION).tar.gz
CLOOP_SITE = http://debian-knoppix.alioth.debian.org/packages/sources/cloop

HOST_CLOOP_DEPENDENCIES = host-zlib

define HOST_CLOOP_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE1) -C $(@D) APPSONLY=yes
endef

define HOST_CLOOP_INSTALL_CMDS
	$(INSTALL) -m 0755 -d $(HOST_DIR)/usr/bin
	$(INSTALL) -m 755 $(@D)/create_compressed_fs $(HOST_DIR)/usr/bin
	$(INSTALL) -m 755 $(@D)/extract_compressed_fs $(HOST_DIR)/usr/bin
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
