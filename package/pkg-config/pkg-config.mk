#############################################################
#
# pkgconfig
#
#############################################################
PKG_CONFIG_VERSION = 0.25
PKG_CONFIG_SOURCE = pkg-config-$(PKG_CONFIG_VERSION).tar.gz
PKG_CONFIG_SITE = http://pkgconfig.freedesktop.org/releases/

PKG_CONFIG_DEPENDENCIES = libglib2

PKG_CONFIG_CONF_OPT = --with-installed-glib

HOST_PKG_CONFIG_CONF_OPT = \
		--with-pc-path="$(STAGING_DIR)/usr/lib/pkgconfig" \
		--with-sysroot="$(STAGING_DIR)" \
		--disable-static

HOST_PKG_CONFIG_AUTORECONF = YES

$(eval $(call AUTOTARGETS,package,pkg-config))
$(eval $(call AUTOTARGETS,package,pkg-config,host))

PKG_CONFIG_HOST_BINARY:=$(HOST_DIR)/usr/bin/pkg-config
