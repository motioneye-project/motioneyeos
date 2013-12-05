################################################################################
#
# liblog4c-localtime
#
################################################################################

LIBLOG4C_LOCALTIME_VERSION = v1.0
LIBLOG4C_LOCALTIME_SITE    = $(call github,rcmadruga,log4c-localtime,$(LIBLOG4C_LOCALTIME_VERSION))
LIBLOG4C_LOCALTIME_INSTALL_STAGING = YES
LIBLOG4C_LOCALTIME_CONF_OPT = --disable-expattest
LIBLOG4C_LOCALTIME_DEPENDENCIES = expat
LIBLOG4C_LOCALTIME_CONFIG_SCRIPTS = log4c-config

define LIBLOG4C_LOCALTIME_FIX_CONFIGURE_PERMS
	chmod +x $(@D)/configure
endef

LIBLOG4C_LOCALTIME_PRE_CONFIGURE_HOOKS += LIBLOG4C_LOCALTIME_FIX_CONFIGURE_PERMS

 $(eval $(autotools-package))
