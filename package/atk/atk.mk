################################################################################
#
# atk
#
################################################################################

ATK_VERSION_MAJOR = 2.28
ATK_VERSION = $(ATK_VERSION_MAJOR).1
ATK_SOURCE = atk-$(ATK_VERSION).tar.xz
ATK_SITE = http://ftp.gnome.org/pub/gnome/sources/atk/$(ATK_VERSION_MAJOR)
ATK_LICENSE = LGPL-2.0+
ATK_LICENSE_FILES = COPYING
ATK_INSTALL_STAGING = YES
ATK_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install
ATK_CONF_OPTS = --disable-glibtest --enable-explicit-deps=no
ATK_DEPENDENCIES = libglib2 host-pkgconf

$(eval $(autotools-package))
