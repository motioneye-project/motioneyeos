#############################################################
#
# libconfig
#
#############################################################
LIBCONFIG_VERSION = 1.4.8
LIBCONFIG_SITE = http://www.hyperrealm.com/libconfig/
LIBCONFIG_INSTALL_STAGING = YES
LIBCONFIG_CONF_OPT = --disable-examples

ifneq ($(BR2_INSTALL_LIBSTDCPP),y)
LIBCONFIG_CONF_OPT += --disable-cxx
endif

$(eval $(autotools-package))
