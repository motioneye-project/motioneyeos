################################################################################
#
# wireguard-tools
#
################################################################################

WIREGUARD_TOOLS_VERSION = 1.0.20200319
WIREGUARD_TOOLS_SITE = https://git.zx2c4.com/wireguard-tools/snapshot
WIREGUARD_TOOLS_SOURCE = wireguard-tools-$(WIREGUARD_TOOLS_VERSION).tar.xz
WIREGUARD_TOOLS_LICENSE = GPL-2.0
WIREGUARD_TOOLS_LICENSE_FILES = COPYING

ifeq ($(BR2_INIT_SYSTEMD),y)
WIREGUARD_TOOLS_MAKE_OPTS += WITH_SYSTEMDUNITS=yes
WIREGUARD_TOOLS_DEPENDENCIES += host-pkgconf
else
WIREGUARD_TOOLS_MAKE_OPTS += WITH_SYSTEMDUNITS=no
endif

ifeq ($(BR2_PACKAGE_BASH),y)
WIREGUARD_TOOLS_MAKE_OPTS += WITH_BASHCOMPLETION=yes WITH_WGQUICK=yes
else
WIREGUARD_TOOLS_MAKE_OPTS += WITH_BASHCOMPLETION=no WITH_WGQUICK=no
endif

define WIREGUARD_TOOLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) $(WIREGUARD_TOOLS_MAKE_OPTS) \
		-C $(@D)/src
endef

define WIREGUARD_TOOLS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) $(WIREGUARD_TOOLS_MAKE_OPTS) \
		-C $(@D)/src install DESTDIR=$(TARGET_DIR)
endef

$(eval $(generic-package))
