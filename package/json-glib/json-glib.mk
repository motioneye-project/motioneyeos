################################################################################
#
# json-glib
#
################################################################################

JSON_GLIB_VERSION_MAJOR = 1.2
JSON_GLIB_VERSION = $(JSON_GLIB_VERSION_MAJOR).8
JSON_GLIB_SITE = http://ftp.gnome.org/pub/GNOME/sources/json-glib/$(JSON_GLIB_VERSION_MAJOR)
JSON_GLIB_SOURCE = json-glib-$(JSON_GLIB_VERSION).tar.xz
JSON_GLIB_LICENSE = LGPL-2.1+
JSON_GLIB_LICENSE_FILES = COPYING
JSON_GLIB_INSTALL_STAGING = YES

JSON_GLIB_DEPENDENCIES = \
	$(TARGET_NLS_DEPENDENCIES) \
	host-pkgconf \
	libglib2

$(eval $(autotools-package))
