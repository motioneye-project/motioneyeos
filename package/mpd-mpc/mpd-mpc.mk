################################################################################
#
# mpd-mpc
#
################################################################################

MPD_MPC_VERSION_MAJOR = 0
MPD_MPC_VERSION = $(MPD_MPC_VERSION_MAJOR).29
MPD_MPC_SITE = http://www.musicpd.org/download/mpc/$(MPD_MPC_VERSION_MAJOR)
MPD_MPC_SOURCE = mpc-$(MPD_MPC_VERSION).tar.xz
MPD_MPC_LICENSE = GPL-2.0+
MPD_MPC_LICENSE_FILES = COPYING
MPD_MPC_DEPENDENCIES = host-meson host-pkgconf libmpdclient

MPD_MPC_CONF_OPTS += \
	--prefix=/usr \
	--buildtype $(if $(BR2_ENABLE_DEBUG),debug,release) \
	--cross-file $(HOST_DIR)/etc/meson/cross-compilation.conf

MPD_MPC_NINJA_OPTS = $(if $(VERBOSE),-v)

define MPD_MPC_CONFIGURE_CMDS
	rm -rf $(@D)/build
	mkdir -p $(@D)/build
	$(TARGET_MAKE_ENV) meson $(MPD_MPC_CONF_OPTS) $(@D) $(@D)/build
endef

define MPD_MPC_BUILD_CMDS
	$(TARGET_MAKE_ENV) ninja $(MPD_MPC_NINJA_OPTS) -C $(@D)/build
endef

define MPD_MPC_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) DESTDIR=$(TARGET_DIR) ninja $(MPD_MPC_NINJA_OPTS) \
		-C $(@D)/build install
endef

$(eval $(generic-package))
