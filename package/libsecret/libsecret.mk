################################################################################
#
# libsecret
#
################################################################################

LIBSECRET_VERSION_MAJOR = 0.18
LIBSECRET_VERSION = $(LIBSECRET_VERSION_MAJOR).4
LIBSECRET_SITE = http://ftp.gnome.org/pub/GNOME/sources/libsecret/$(LIBSECRET_VERSION_MAJOR)
LIBSECRET_SOURCE = libsecret-$(LIBSECRET_VERSION).tar.xz
LIBSECRET_INSTALL_STAGING = YES
LIBSECRET_DEPENDENCIES = libglib2 host-intltool
LIBSECRET_CONF_OPTS = \
	--disable-manpages \
	--disable-strict \
	--disable-coverage \
	--enable-introspection=no \
	--enable-vala=no
LIBSECRET_LICENSE = LGPLv2.1+
LIBSECRET_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
LIBSECRET_DEPENDENCIES += libgcrypt
LIBSECRET_CONF_OPTS += --enable-gcrypt \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
LIBSECRET_CONF_OPTS += --disable-gcrypt
endif

$(eval $(autotools-package))
