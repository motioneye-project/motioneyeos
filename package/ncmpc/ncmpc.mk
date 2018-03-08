################################################################################
#
# ncmpc
#
################################################################################

NCMPC_VERSION_MAJOR = 0
NCMPC_VERSION = $(NCMPC_VERSION_MAJOR).29
NCMPC_SOURCE = ncmpc-$(NCMPC_VERSION).tar.xz
NCMPC_SITE = http://www.musicpd.org/download/ncmpc/$(NCMPC_VERSION_MAJOR)
NCMPC_DEPENDENCIES = host-meson host-pkgconf libglib2 libmpdclient ncurses
NCMPC_LICENSE = GPL-2.0+
NCMPC_LICENSE_FILES = COPYING

NCMPC_CONF_OPTS += \
	--prefix=/usr \
	--buildtype $(if $(BR2_ENABLE_DEBUG),debug,release) \
	--cross-file $(HOST_DIR)/etc/meson/cross-compilation.conf

NCMPC_NINJA_OPTS = $(if $(VERBOSE),-v)

define NCMPC_CONFIGURE_CMDS
	rm -rf $(@D)/build
	mkdir -p $(@D)/build
	$(TARGET_MAKE_ENV) meson $(NCMPC_CONF_OPTS) $(@D) $(@D)/build
endef

define NCMPC_BUILD_CMDS
	$(TARGET_MAKE_ENV) ninja $(NCMPC_NINJA_OPTS) -C $(@D)/build
endef

define NCMPC_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) DESTDIR=$(TARGET_DIR) \
		ninja $(NCMPC_NINJA_OPTS) -C $(@D)/build install
endef

$(eval $(generic-package))
