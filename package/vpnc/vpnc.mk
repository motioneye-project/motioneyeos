################################################################################
#
# vpnc
#
################################################################################

VPNC_VERSION = 0.5.3
VPNC_SITE = http://www.unix-ag.uni-kl.de/~massar/vpnc
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
