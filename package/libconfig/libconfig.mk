################################################################################
#
# libconfig
#
################################################################################

LIBCONFIG_VERSION = v1.7.2
LIBCONFIG_SITE = $(call github,hyperrealm,libconfig,$(LIBCONFIG_VERSION))
LIBCONFIG_LICENSE = LGPL-2.1+
LIBCONFIG_LICENSE_FILES = COPYING.LIB
LIBCONFIG_INSTALL_STAGING = YES
# From git
LIBCONFIG_AUTORECONF = YES
LIBCONFIG_CONF_OPTS = --disable-examples

ifneq ($(BR2_INSTALL_LIBSTDCPP),y)
LIBCONFIG_CONF_OPTS += --disable-cxx
endif

$(eval $(autotools-package))
