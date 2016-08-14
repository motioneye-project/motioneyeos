################################################################################
#
# vpnc
#
################################################################################

VPNC_VERSION = 70f1211f6f26e87e374d66f9a986e855215b8e3e
VPNC_SITE = $(call github,ndpgroup,vpnc,$(VPNC_VERSION))
VPNC_LICENSE = GPLv2+
VPNC_LICENSE_FILES = COPYING

VPNC_DEPENDENCIES = libgcrypt libgpg-error

VPNC_LDFLAGS = $(TARGET_LDFLAGS) -lgcrypt -lgpg-error
VPNC_CPPFLAGS = -DVERSION=\\\"$(VPNC_VERSION)\\\"

define VPNC_BUILD_CMDS
	$(MAKE)	-C $(@D) $(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(VPNC_CPPFLAGS)" LDFLAGS="$(VPNC_LDFLAGS)"
endef

define VPNC_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) install $(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(VPNC_CPPFLAGS)" LDFLAGS="$(VPNC_LDFLAGS)" \
		DESTDIR="$(TARGET_DIR)" PREFIX=/usr
endef

$(eval $(generic-package))
