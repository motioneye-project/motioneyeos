################################################################################
#
# vpnc
#
################################################################################

VPNC_VERSION = b1243d29e0c00312ead038b04a2cf5e2fa31d740
VPNC_SITE = $(call github,ndpgroup,vpnc,$(VPNC_VERSION))
VPNC_LICENSE = GPLv2+
VPNC_LICENSE_FILES = COPYING

VPNC_DEPENDENCIES = libgcrypt libgpg-error gnutls host-pkgconf

define VPNC_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(TARGET_CONFIGURE_OPTS) \
		LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config \
		VERSION=$(VPNC_VERSION) MANS=
endef

define VPNC_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install $(TARGET_CONFIGURE_OPTS) \
		VERSION=$(VPNC_VERSION) MANS= \
		DESTDIR="$(TARGET_DIR)" PREFIX=/usr
endef

$(eval $(generic-package))
