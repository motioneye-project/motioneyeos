################################################################################
#
# libmpdclient
#
################################################################################

LIBMPDCLIENT_VERSION_MAJOR = 2
LIBMPDCLIENT_VERSION = $(LIBMPDCLIENT_VERSION_MAJOR).14
LIBMPDCLIENT_SOURCE = libmpdclient-$(LIBMPDCLIENT_VERSION).tar.xz
LIBMPDCLIENT_SITE = http://www.musicpd.org/download/libmpdclient/$(LIBMPDCLIENT_VERSION_MAJOR)
LIBMPDCLIENT_INSTALL_STAGING = YES
LIBMPDCLIENT_LICENSE = BSD-3-Clause
LIBMPDCLIENT_LICENSE_FILES = COPYING
LIBMPDCLIENT_DEPENDENCIES = host-meson

LIBMPDCLIENT_CONF_OPTS += \
	--prefix=/usr \
	--buildtype $(if $(BR2_ENABLE_DEBUG),debug,release) \
	--cross-file $(HOST_DIR)/etc/meson/cross-compilation.conf

LIBMPDCLIENT_NINJA_OPTS = $(if $(VERBOSE),-v)

define LIBMPDCLIENT_CONFIGURE_CMDS
	rm -rf $(@D)/build
	mkdir -p $(@D)/build
	$(TARGET_MAKE_ENV) meson $(LIBMPDCLIENT_CONF_OPTS) $(@D) $(@D)/build
endef

define LIBMPDCLIENT_BUILD_CMDS
	$(TARGET_MAKE_ENV) ninja $(LIBMPDCLIENT_NINJA_OPTS) -C $(@D)/build
endef

define LIBMPDCLIENT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) DESTDIR=$(TARGET_DIR) \
		ninja $(LIBMPDCLIENT_NINJA_OPTS) -C $(@D)/build install
endef

define LIBMPDCLIENT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) DESTDIR=$(STAGING_DIR) \
		ninja $(LIBMPDCLIENT_NINJA_OPTS) -C $(@D)/build install
endef

$(eval $(generic-package))
