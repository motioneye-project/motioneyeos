################################################################################
#
# gcr
#
################################################################################

GCR_VERSION_MAJOR = 3.20
GCR_VERSION = $(GCR_VERSION_MAJOR).0
GCR_SITE = http://ftp.acc.umu.se/pub/gnome/sources/gcr/$(GCR_VERSION_MAJOR)
GCR_SOURCE = gcr-$(GCR_VERSION).tar.xz
GCR_DEPENDENCIES = host-intltool host-pkgconf libgcrypt libglib2 p11-kit
GCR_INSTALL_STAGING = YES
GCR_CONF_ENV = ac_cv_path_GNUPG=/usr/bin/gpg2
GCR_CONF_OPTS = \
	--disable-gtk-doc \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr
# Even though COPYING is v2 the code states v2.1+
GCR_LICENSE = LGPL-2.1+
GCR_LICENSE_FILES = COPYING

# Only the X11 backend is supported for the simple GUI
ifeq ($(BR2_PACKAGE_LIBGTK3_X11),y)
GCR_DEPENDENCIES += libgtk3
GCR_CONF_OPTS += --with-gtk
else
GCR_CONF_OPTS += --without-gtk
endif

$(eval $(autotools-package))
