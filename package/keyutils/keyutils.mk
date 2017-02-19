################################################################################
#
# keyutils
#
################################################################################

KEYUTILS_VERSION = 1.5.9
KEYUTILS_SOURCE = keyutils-$(KEYUTILS_VERSION).tar.bz2
KEYUTILS_SITE = http://people.redhat.com/~dhowells/keyutils
KEYUTILS_LICENSE = GPLv2+, LGPLv2.1+
KEYUTILS_LICENSE_FILES = LICENCE.GPL LICENCE.LGPL
KEYUTILS_INSTALL_STAGING = YES

KEYUTILS_MAKE_PARAMS =                    \
	INSTALL=$(INSTALL)                \
	LIBDIR=/usr/lib                   \
	USRLIBDIR=/usr/lib                \
	CFLAGS="$(TARGET_CFLAGS)"         \
	CPPFLAGS="$(TARGET_CPPFLAGS) -I." \
	LNS="$(HOSTLN) -sf"

ifeq ($(BR2_SHARED_LIBS),y)
KEYUTILS_MAKE_PARAMS += NO_ARLIB=1
endif

define KEYUTILS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) $(KEYUTILS_MAKE_PARAMS) -C $(@D)
endef

define KEYUTILS_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) $(KEYUTILS_MAKE_PARAMS) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

define KEYUTILS_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) $(KEYUTILS_MAKE_PARAMS) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
