################################################################################
#
# keyutils
#
################################################################################

KEYUTILS_VERSION         = 1.5.5
KEYUTILS_SOURCE          = keyutils-$(KEYUTILS_VERSION).tar.bz2
KEYUTILS_SITE            = http://people.redhat.com/~dhowells/keyutils
KEYUTILS_LICENSE         = GPLv2+ LGPLv2.1+
KEYUTILS_LICENSE_FILES   = LICENCE.GPL LICENCE.LGPL
KEYUTILS_INSTALL_STAGING = YES

KEYUTILS_MAKE_ENV =     \
    INSTALL=$(INSTALL)  \
    LIBDIR=/usr/lib     \
    USRLIBDIR=/usr/lib  \
    LN=$(HOSTLN)        \

define KEYUTILS_BUILD_CMDS
	$(KEYUTILS_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define KEYUTILS_INSTALL_STAGING_CMDS
	$(KEYUTILS_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

define KEYUTILS_INSTALL_TARGET_CMDS
	$(KEYUTILS_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
