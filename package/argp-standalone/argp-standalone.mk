################################################################################
#
# argp-standalone
#
################################################################################

ARGP_STANDALONE_VERSION = 1.3
ARGP_STANDALONE_SITE = http://www.lysator.liu.se/~nisse/archive
ARGP_STANDALONE_INSTALL_STAGING = YES
ARGP_STANDALONE_LICENSE = LGPL-2.0+

ARGP_STANDALONE_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) -fPIC -fgnu89-inline"

define ARGP_STANDALONE_INSTALL_STAGING_CMDS
	$(INSTALL) -D $(@D)/libargp.a $(STAGING_DIR)/usr/lib/libargp.a
	$(INSTALL) -D $(@D)/argp.h $(STAGING_DIR)/usr/include/argp.h
endef

define ARGP_STANDALONE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/libargp.a $(TARGET_DIR)/usr/lib/libargp.a
	$(INSTALL) -D $(@D)/argp.h $(TARGET_DIR)/usr/include/argp.h
endef

$(eval $(autotools-package))
