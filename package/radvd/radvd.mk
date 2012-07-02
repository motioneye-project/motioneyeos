#############################################################
#
# radvd
#
#############################################################

RADVD_VERSION = 1.9.1
RADVD_SITE = http://www.litech.org/radvd/dist
RADVD_DEPENDENCIES = flex libdaemon host-flex host-pkg-config
RADVD_AUTORECONF = YES

define RADVD_INSTALL_INITSCRIPT
	$(INSTALL) -m 0755 package/radvd/S50radvd $(TARGET_DIR)/etc/init.d
endef

RADVD_POST_INSTALL_TARGET_HOOKS += RADVD_INSTALL_INITSCRIPT

$(eval $(autotools-package))
