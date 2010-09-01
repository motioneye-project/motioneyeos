#############################################################
#
# radvd
#
#############################################################
RADVD_VERSION:=1.6
RADVD_SOURCE:=radvd-$(RADVD_VERSION).tar.gz
RADVD_SITE:=http://www.litech.org/radvd/dist/
RADVD_DEPENDENCIES:=flex host-flex
RADVD_CONF_OPT:= --program-prefix=''

define RADVD_INSTALL_INITSCRIPT
	$(INSTALL) -m 0755 package/radvd/S50radvd $(TARGET_DIR)/etc/init.d
endef

RADVD_POST_INSTALL_TARGET_HOOKS += RADVD_INSTALL_INITSCRIPT

$(eval $(call AUTOTARGETS,package,radvd))
