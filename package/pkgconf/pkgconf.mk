################################################################################
#
# pkgconf
#
################################################################################

PKGCONF_VERSION = 0.8.9
PKGCONF_SITE = http://rabbit.dereferenced.org/~nenolod/distfiles/
PKGCONF_SOURCE = pkgconf-$(PKGCONF_VERSION).tar.bz2
PKGCONF_LICENSE = pkgconf license
PKGCONF_LICENSE_FILES = COPYING

PKG_CONFIG_HOST_BINARY = $(HOST_DIR)/usr/bin/pkg-config

define PKGCONF_LINK_PKGCONFIG
	ln -sf pkgconf $(TARGET_DIR)/usr/bin/pkg-config
endef

define HOST_PKGCONF_INSTALL_WRAPPER
	$(INSTALL) -m 0755 -D package/pkgconf/pkg-config.in \
		$(HOST_DIR)/usr/bin/pkg-config
	$(SED) 's,@PKG_CONFIG_LIBDIR@,$(STAGING_DIR)/usr/lib/pkgconfig:$(STAGING_DIR)/usr/share/pkgconfig,' \
		-e 's,@STAGING_DIR@,$(STAGING_DIR),' \
		$(HOST_DIR)/usr/bin/pkg-config
endef

PKGCONF_POST_INSTALL_TARGET_HOOKS += PKGCONF_LINK_PKGCONFIG
HOST_PKGCONF_POST_INSTALL_HOOKS += HOST_PKGCONF_INSTALL_WRAPPER

$(eval $(autotools-package))
$(eval $(host-autotools-package))
