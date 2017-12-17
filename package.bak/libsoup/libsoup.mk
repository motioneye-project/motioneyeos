################################################################################
#
# libsoup
#
################################################################################

LIBSOUP_VERSION_MAJOR = 2.56
LIBSOUP_VERSION = $(LIBSOUP_VERSION_MAJOR).0
LIBSOUP_SOURCE = libsoup-$(LIBSOUP_VERSION).tar.xz
LIBSOUP_SITE = http://ftp.gnome.org/pub/gnome/sources/libsoup/$(LIBSOUP_VERSION_MAJOR)
LIBSOUP_LICENSE = LGPLv2+
LIBSOUP_LICENSE_FILES = COPYING
LIBSOUP_INSTALL_STAGING = YES
LIBSOUP_CONF_ENV = ac_cv_path_GLIB_GENMARSHAL=$(LIBGLIB2_HOST_BINARY)
LIBSOUP_CONF_OPTS = --disable-glibtest --enable-vala=no --with-gssapi=no
LIBSOUP_DEPENDENCIES = host-pkgconf host-libglib2 \
	libglib2 libxml2 sqlite host-intltool

ifeq ($(BR2_PACKAGE_LIBSOUP_GNOME),y)
LIBSOUP_CONF_OPTS += --with-gnome
else
LIBSOUP_CONF_OPTS += --without-gnome
endif

ifeq ($(BR2_PACKAGE_LIBSOUP_SSL),y)
LIBSOUP_DEPENDENCIES += glib-networking
else
LIBSOUP_CONF_OPTS += --disable-tls-check
endif

$(eval $(autotools-package))
