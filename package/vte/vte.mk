################################################################################
#
# vte
#
################################################################################

VTE_VERSION = 0.48.3
VTE_SOURCE = vte-$(VTE_VERSION).tar.xz
VTE_SITE = http://ftp.gnome.org/pub/gnome/sources/vte/0.48
VTE_DEPENDENCIES = host-intltool host-pkgconf libgtk3 libxml2 pcre2
VTE_LICENSE = LGPL-2.1+
VTE_LICENSE_FILES = COPYING
VTE_CONF_OPTS += --disable-vala

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
VTE_CONF_OPTS += --enable-introspection
VTE_DEPENDENCIES += gobject-introspection
else
VTE_CONF_OPTS += --disable-introspection
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
VTE_CONF_OPTS += --with-gnutls
VTE_DEPENDENCIES += gnutls
else
VTE_CONF_OPTS += --without-gnutls
endif

$(eval $(autotools-package))
