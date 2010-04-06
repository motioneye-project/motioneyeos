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

$(eval $(call AUTOTARGETS,package,radvd))

$(RADVD_HOOK_POST_INSTALL): $(RADVD_TARGET_INSTALL_TARGET)
	$(INSTALL) -m 0755 package/radvd/S50radvd $(TARGET_DIR)/etc/init.d
	touch $@
