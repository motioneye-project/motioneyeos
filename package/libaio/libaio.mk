################################################################################
#
# libaio
#
################################################################################

LIBAIO_VERSION = 0.3.110
LIBAIO_SOURCE = libaio_$(LIBAIO_VERSION).orig.tar.gz
LIBAIO_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/liba/libaio
LIBAIO_INSTALL_STAGING = YES
LIBAIO_LICENSE = LGPLv2.1+
LIBAIO_LICENSE_FILES = COPYING

LIBAIO_CONFIGURE_OPTS = $(TARGET_CONFIGURE_OPTS)

ifeq ($(BR2_STATIC_LIBS),y)
LIBAIO_CONFIGURE_OPTS += ENABLE_SHARED=0
endif

# On PowerPC, a weird toolchain issue causes -Os builds to produce
# references to hidden symbols, so we're forcing -O2
ifeq ($(BR2_powerpc),y)
LIBAIO_CONFIGURE_OPTS += CFLAGS="$(subst -Os,-O2,$(TARGET_CFLAGS))"
endif

define LIBAIO_BUILD_CMDS
	$(LIBAIO_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define LIBAIO_INSTALL_STAGING_CMDS
	$(LIBAIO_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

define LIBAIO_INSTALL_TARGET_CMDS
	$(LIBAIO_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
