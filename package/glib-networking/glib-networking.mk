#############################################################
#
# glib-networking
#
#############################################################

GLIB_NETWORKING_MAJOR_VERSION = 2.30
GLIB_NETWORLING_MINOR_VERSION = 2
GLIB_NETWORKING_VERSION = $(GLIB_NETWORKING_MAJOR_VERSION).$(GLIB_NETWORLING_MINOR_VERSION)
GLIB_NETWORKING_SITE = http://ftp.gnome.org/pub/gnome/sources/glib-networking/$(GLIB_NETWORKING_MAJOR_VERSION)
GLIB_NETWORKING_SOURCE = glib-networking-$(GLIB_NETWORKING_VERSION).tar.xz

GLIB_NETWORKING_INSTALL_STAGING = YES

GLIB_NETWORKING_DEPENDENCIES = \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl) \
	host-pkg-config \
	host-intltool \
	libglib2

ifeq ($(BR2_PACKAGE_GNUTLS),y)
GLIB_NETWORKING_DEPENDENCIES += gnutls
GLIB_NETWORKING_CONF_OPT += --with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
GLIB_NETWORKING_CONF_OPT += --without-gnutls
endif

$(eval $(autotools-package))
