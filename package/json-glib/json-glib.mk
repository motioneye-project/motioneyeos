################################################################################
#
# json-glib
#
################################################################################

JSON_GLIB_VERSION_MAJOR = 0.14
JSON_GLIB_VERSION_MINOR = 2
JSON_GLIB_VERSION = $(JSON_GLIB_VERSION_MAJOR).$(JSON_GLIB_VERSION_MINOR)
JSON_GLIB_SITE = http://ftp.gnome.org/pub/GNOME/sources/json-glib/$(JSON_GLIB_VERSION_MAJOR)
JSON_GLIB_SOURCE = json-glib-$(JSON_GLIB_VERSION).tar.xz
JSON_GLIB_LICENSE = LGPLv2.1+
JSON_GLIB_LICENSE_FILES = COPYING
JSON_GLIB_INSTALL_STAGING = YES

JSON_GLIB_DEPENDENCIES = \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext) \
	host-pkgconf \
	libglib2

$(eval $(autotools-package))
