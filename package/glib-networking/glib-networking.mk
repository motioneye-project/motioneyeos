################################################################################
#
# glib-networking
#
################################################################################

GLIB_NETWORKING_VERSION_MAJOR = 2.58
GLIB_NETWORKING_VERSION = $(GLIB_NETWORKING_VERSION_MAJOR).0
GLIB_NETWORKING_SITE = http://ftp.gnome.org/pub/gnome/sources/glib-networking/$(GLIB_NETWORKING_VERSION_MAJOR)
GLIB_NETWORKING_SOURCE = glib-networking-$(GLIB_NETWORKING_VERSION).tar.xz
GLIB_NETWORKING_INSTALL_STAGING = YES
GLIB_NETWORKING_DEPENDENCIES = \
	$(TARGET_NLS_DEPENDENCIES) \
	host-pkgconf \
	host-intltool \
	libglib2 \
	gnutls

GLIB_NETWORKING_CONF_OPTS = \
	-Dca_certificates_path=/etc/ssl/certs/ca-certificates.crt \
	-Dlibproxy_support=false \
	-Dgnome_proxy_support=false \
	-Dpkcs11_support=false

GLIB_NETWORKING_LICENSE = LGPL-2.0+
GLIB_NETWORKING_LICENSE_FILES = COPYING
GLIB_NETWORKING_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) \
	GIO_MODULE_DIR=/usr/lib/gio/modules install

$(eval $(meson-package))
