################################################################################
#
# libavl
#
################################################################################

LIBAVL_VERSION = 0.3.5
LIBAVL_SITE = http://snapshot.debian.org/archive/debian/20050312T000000Z/pool/main/liba/libavl
LIBAVL_SOURCE = libavl_$(LIBAVL_VERSION).orig.tar.gz
LIBAVL_LICENSE = LGPL-2.0+
LIBAVL_LICENSE_FILES = COPYING
LIBAVL_INSTALL_STAGING = YES

LIBAVL_CFLAGS = $(TARGET_CFLAGS) -fPIC
HOST_LIBAVL_CFLAGS = $(HOST_CFLAGS) -fPIC

define LIBAVL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		CFLAGS="$(LIBAVL_CFLAGS)"
endef

define LIBAVL_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) install \
		prefix=/usr DESTDIR=$(STAGING_DIR)
endef

define LIBAVL_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) install \
		prefix=/usr DESTDIR=$(TARGET_DIR)
endef

define HOST_LIBAVL_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D) \
		CFLAGS="$(HOST_LIBAVL_CFLAGS)"
endef

define HOST_LIBAVL_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D) install \
		prefix=$(HOST_DIR)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
