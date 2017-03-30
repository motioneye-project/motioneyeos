################################################################################
#
# neard
#
################################################################################

NEARD_VERSION = 0.14
NEARD_SOURCE = neard-$(NEARD_VERSION).tar.xz
NEARD_SITE = $(BR2_KERNEL_MIRROR)/linux/network/nfc
NEARD_LICENSE = GPL-2.0
NEARD_LICENSE_FILES = COPYING

NEARD_DEPENDENCIES = host-pkgconf dbus libglib2 libnl
NEARD_CONF_OPTS = --disable-traces

ifeq ($(BR2_PACKAGE_NEARD_TOOLS),y)
NEARD_CONF_OPTS += --enable-tools
endif

define NEARD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/neard/S53neard \
		$(TARGET_DIR)/etc/init.d/S53neard
endef

$(eval $(autotools-package))
