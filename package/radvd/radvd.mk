#############################################################
#
# radvd
#
#############################################################
RADVD_VERSION:=1.2
RADVD_SOURCE:=radvd-$(RADVD_VERSION).tar.gz
RADVD_SITE:=http://www.litech.org/radvd/dist/
RADVD_AUTORECONF:=no
RADVD_INSTALL_STAGING:=no
RADVD_INSTALL_TARGET:=YES
RADVD_DEPENDENCIES:=uclibc flex
RADVD_MAKE:=$(MAKE1)
RADVD_CONF_OPT:= --program-prefix=''

$(eval $(call AUTOTARGETS,package,radvd))

$(RADVD_HOOK_POST_INSTALL): $(RADVD_TARGET_INSTALL_TARGET)
	$(INSTALL) -m 0755 package/radvd/S50radvd $(TARGET_DIR)/etc/init.d
	touch $@
