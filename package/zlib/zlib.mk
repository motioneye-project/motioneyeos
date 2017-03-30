################################################################################
#
# zlib
#
################################################################################

ZLIB_VERSION = 1.2.11
ZLIB_SOURCE = zlib-$(ZLIB_VERSION).tar.xz
ZLIB_SITE = http://www.zlib.net
ZLIB_LICENSE = Zlib
ZLIB_LICENSE_FILES = README
ZLIB_INSTALL_STAGING = YES

# It is not possible to build only a shared version of zlib, so we build both
# shared and static, unless we only want the static libs, and we eventually
# selectively remove what we do not want
ifeq ($(BR2_STATIC_LIBS),y)
ZLIB_PIC =
ZLIB_SHARED = --static
else
ZLIB_PIC = -fPIC
ZLIB_SHARED = --shared
endif

define ZLIB_CONFIGURE_CMDS
	(cd $(@D); rm -rf config.cache; \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) $(ZLIB_PIC)" \
		./configure \
		$(ZLIB_SHARED) \
		--prefix=/usr \
	)
endef

define HOST_ZLIB_CONFIGURE_CMDS
	(cd $(@D); rm -rf config.cache; \
		$(HOST_CONFIGURE_ARGS) \
		$(HOST_CONFIGURE_OPTS) \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
	)
endef

define ZLIB_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D)
endef

define HOST_ZLIB_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE1) -C $(@D)
endef

define ZLIB_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) DESTDIR=$(STAGING_DIR) LDCONFIG=true install
endef

define ZLIB_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) DESTDIR=$(TARGET_DIR) LDCONFIG=true install
endef

# We don't care removing the .a from target, since it not used at link
# time to build other packages, and it is anyway removed later before
# assembling the filesystem images anyway.
ifeq ($(BR2_SHARED_LIBS),y)
define ZLIB_RM_STATIC_STAGING
	rm -f $(STAGING_DIR)/usr/lib/libz.a
endef
ZLIB_POST_INSTALL_STAGING_HOOKS += ZLIB_RM_STATIC_STAGING
endif

define HOST_ZLIB_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE1) -C $(@D) LDCONFIG=true install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
