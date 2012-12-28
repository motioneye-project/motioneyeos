NETTLE_VERSION = 2.5
NETTLE_SITE = http://www.lysator.liu.se/~nisse/archive
NETTLE_DEPENDENCIES = gmp
NETTLE_INSTALL_STAGING = YES

define NETTLE_DITCH_DEBUGGING_CFLAGS
	$(SED) '/CFLAGS/ s/ -ggdb3//' $(@D)/configure
endef

NETTLE_POST_EXTRACT_HOOKS += NETTLE_DITCH_DEBUGGING_CFLAGS

$(eval $(autotools-package))
