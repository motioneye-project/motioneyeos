################################################################################
#
# glib-networking
#
################################################################################

GLIB_NETWORKING_VERSION_MAJOR = 2.50
GLIB_NETWORKING_VERSION = $(GLIB_NETWORKING_VERSION_MAJOR).0
GLIB_NETWORKING_SITE = http://ftp.gnome.org/pub/gnome/sources/glib-networking/$(GLIB_NETWORKING_VERSION_MAJOR)
GLIB_NETWORKING_SOURCE = glib-networking-$(GLIB_NETWORKING_VERSION).tar.xz
GLIB_NETWORKING_INSTALL_STAGING = YES
GLIB_NETWORKING_DEPENDENCIES = \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext) \
	host-pkgconf \
	host-intltool \
	libglib2
GLIB_NETWORKING_CONF_OPTS = \
	--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt
GLIB_NETWORKING_LICENSE = LGPLv2+
GLIB_NETWORKING_LICENSE_FILES = COPYING
GLIB_NETWORKING_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) \
	GIO_MODULE_DIR=/usr/lib/gio/modules install

ifeq ($(BR2_PACKAGE_GNUTLS),y)
GLIB_NETWORKING_DEPENDENCIES += gnutls
GLIB_NETWORKING_CONF_OPTS += --with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
GLIB_NETWORKING_CONF_OPTS += --without-gnutls
endif

$(eval $(autotools-package))
