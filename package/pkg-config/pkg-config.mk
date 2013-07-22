################################################################################
#
# pkg-config
#
################################################################################

PKG_CONFIG_VERSION = 0.25
PKG_CONFIG_SOURCE = pkg-config-$(PKG_CONFIG_VERSION).tar.gz
PKG_CONFIG_SITE = http://pkgconfig.freedesktop.org/releases/
PKG_CONFIG_DEPENDENCIES = libglib2
PKG_CONFIG_CONF_OPT = --with-installed-glib

$(eval $(autotools-package))
