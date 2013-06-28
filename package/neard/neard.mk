################################################################################
#
# neard
#
################################################################################

NEARD_VERSION = 0.12
NEARD_SITE = $(BR2_KERNEL_MIRROR)/linux/network/nfc
NEARD_LICENSE = GPLv2
NEARD_LICENSE_FILES = COPYING

NEARD_AUTORECONF = YES
NEARD_DEPENDENCIES = host-pkgconf dbus libglib2 libnl
NEARD_CONF_OPT = --disable-traces

ifeq ($(BR2_PACKAGE_NEARD_TOOLS),y)
	NEARD_CONF_OPT += --enable-tools
endif

define NEARD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/neard/S53neard \
		$(TARGET_DIR)/etc/init.d/S53neard
endef

define NEARD_UNINSTALL_INIT_SYSV
	$(RM) $(TARGET_DIR)/etc/init.d/S53neard
endef

$(eval $(autotools-package))
