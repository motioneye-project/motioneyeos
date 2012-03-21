#############################################################
#
# libconfig
#
#############################################################
LIBCONFIG_VERSION = 1.4.8
LIBCONFIG_SITE = http://www.hyperrealm.com/libconfig/
LIBCONFIG_INSTALL_STAGING = YES

ifneq ($(BR2_INSTALL_LIBSTDCPP),y)
LIBCONFIG_CONF_OPT = --disable-cxx
endif

$(eval $(call AUTOTARGETS))
