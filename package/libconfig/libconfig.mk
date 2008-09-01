#############################################################
#
# libconfig
#
#############################################################
LIBCONFIG_VERSION:=1.3
LIBCONFIG_SOURCE:=libconfig-$(LIBCONFIG_VERSION).tar.gz
LIBCONFIG_SITE:=http://www.hyperrealm.com/libconfig/
LIBCONFIG_AUTORECONF:=NO
LIBCONFIG_INSTALL_STAGING:=YES
LIBCONFIG_INSTALL_TARGET:=YES
LIBCONFIG_INSTALL_TARGET_OPT:=DESTDIR=$(TARGET_DIR) install-strip

ifneq ($(BR2_INSTALL_LIBSTDCPP),y)
LIBCONFIG_CONF_OPT:=--disable-cxx
endif

LIBCONFIG_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,libconfig))
