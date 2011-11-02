#############################################################
#
# radvd
#
#############################################################

RADVD_VERSION = 1.8.3
RADVD_SITE = http://www.litech.org/radvd/dist/
RADVD_DEPENDENCIES = flex host-flex

define RADVD_INSTALL_INITSCRIPT
	$(INSTALL) -m 0755 package/radvd/S50radvd $(TARGET_DIR)/etc/init.d
endef

RADVD_POST_INSTALL_TARGET_HOOKS += RADVD_INSTALL_INITSCRIPT

$(eval $(call AUTOTARGETS))
