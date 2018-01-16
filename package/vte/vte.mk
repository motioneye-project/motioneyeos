################################################################################
#
# vte
#
################################################################################

VTE_VERSION = 0.48.3
VTE_SOURCE = vte-$(VTE_VERSION).tar.xz
VTE_SITE = http://ftp.gnome.org/pub/gnome/sources/vte/0.48
VTE_DEPENDENCIES = host-pkgconf libgtk3 libxml2 pcre2
VTE_LICENSE = LGPL-2.1+
VTE_LICENSE_FILES = COPYING
VTE_CONF_OPTS += --disable-introspection --without-gnutls --disable-vala

$(eval $(autotools-package))
