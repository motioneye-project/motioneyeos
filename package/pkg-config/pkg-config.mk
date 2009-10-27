#############################################################
#
# pkgconfig
#
#############################################################
PKG_CONFIG_VERSION = 0.23
PKG_CONFIG_SOURCE = pkg-config-$(PKG_CONFIG_VERSION).tar.gz
PKG_CONFIG_SITE = http://pkgconfig.freedesktop.org/releases/

ifeq ($(BR2_ENABLE_DEBUG),y) # install-exec doesn't install aclocal stuff
PKG_CONFIG_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
endif

PKG_CONFIG_DEPENDENCIES = libglib2

PKG_CONFIG_CONF_OPT = --with-installed-glib

HOST_PKG_CONFIG_CONF_OPT = \
		--with-pc-path="$(STAGING_DIR)/usr/lib/pkgconfig" \
		--disable-static

define HOST_PKG_CONFIG_INSTALL_M4
install -D -m 0644 $(HOST_DIR)/usr/share/aclocal/pkg.m4 \
		$(STAGING_DIR)/usr/share/aclocal/pkg.m4
endef

HOST_PKG_CONFIG_POST_INSTALL_HOOKS += HOST_PKG_CONFIG_INSTALL_M4

$(eval $(call AUTOTARGETS,package,pkg-config))
$(eval $(call AUTOTARGETS,package,pkg-config,host))

PKG_CONFIG_HOST_BINARY:=$(HOST_DIR)/usr/bin/pkg-config
