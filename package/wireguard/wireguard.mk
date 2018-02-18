################################################################################
#
# wireguard
#
################################################################################

WIREGUARD_VERSION = 0.0.20180218
WIREGUARD_SITE = https://git.zx2c4.com/WireGuard/snapshot
WIREGUARD_SOURCE = WireGuard-$(WIREGUARD_VERSION).tar.xz
WIREGUARD_LICENSE = GPL-2.0
WIREGUARD_LICENSE_FILES = COPYING
WIREGUARD_DEPENDENCIES = host-pkgconf libmnl

ifeq ($(BR2_INIT_SYSTEMD),y)
WIREGUARD_MAKE_OPTS += WITH_SYSTEMDUNITS=yes
else
WIREGUARD_MAKE_OPTS += WITH_SYSTEMDUNITS=no
endif

ifeq ($(BR2_PACKAGE_BASH),y)
WIREGUARD_MAKE_OPTS += WITH_BASHCOMPLETION=yes WITH_WGQUICK=yes
else
WIREGUARD_MAKE_OPTS += WITH_BASHCOMPLETION=no WITH_WGQUICK=no
endif

define WIREGUARD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) $(WIREGUARD_MAKE_OPTS) \
		-C $(@D)/src/tools
endef

define WIREGUARD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) $(WIREGUARD_MAKE_OPTS) \
		-C $(@D)/src/tools install DESTDIR=$(TARGET_DIR)
endef

ifeq ($(BR2_LINUX_KERNEL),y)
WIREGUARD_MODULE_SUBDIRS = src
$(eval $(kernel-module))
endif

$(eval $(generic-package))
