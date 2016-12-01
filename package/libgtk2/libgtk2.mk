################################################################################
#
# libgtk2
#
################################################################################

LIBGTK2_VERSION_MAJOR = 2.24
LIBGTK2_VERSION = $(LIBGTK2_VERSION_MAJOR).31
LIBGTK2_SOURCE = gtk+-$(LIBGTK2_VERSION).tar.xz
LIBGTK2_SITE = http://ftp.gnome.org/pub/gnome/sources/gtk+/$(LIBGTK2_VERSION_MAJOR)
LIBGTK2_INSTALL_STAGING = YES
LIBGTK2_LICENSE = LGPLv2+
LIBGTK2_LICENSE_FILES = COPYING
# For 0001-reduce-dependencies.patch
LIBGTK2_AUTORECONF = YES

LIBGTK2_CONF_ENV = \
	ac_cv_path_GTK_UPDATE_ICON_CACHE=$(HOST_DIR)/usr/bin/gtk-update-icon-cache \
	ac_cv_path_GDK_PIXBUF_CSOURCE=$(HOST_DIR)/usr/bin/gdk-pixbuf-csource \
	DB2HTML=false

LIBGTK2_CONF_OPTS = --disable-glibtest --enable-explicit-deps=no

LIBGTK2_DEPENDENCIES = host-pkgconf host-libgtk2 libglib2 cairo pango atk gdk-pixbuf

# Xorg dependencies
LIBGTK2_CONF_OPTS += \
	--with-x \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib \
	--with-gdktarget=x11
LIBGTK2_DEPENDENCIES += \
	fontconfig xlib_libX11 xlib_libXext xlib_libXrender

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
LIBGTK2_CONF_OPTS += --enable-xinerama
LIBGTK2_DEPENDENCIES += xlib_libXinerama
else
LIBGTK2_CONF_OPTS += --disable-xinerama
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXI),y)
LIBGTK2_CONF_OPTS += --with-xinput=yes
LIBGTK2_DEPENDENCIES += xlib_libXi
else
LIBGTK2_CONF_OPTS += --with-xinput=no
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
LIBGTK2_DEPENDENCIES += xlib_libXrandr
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCURSOR),y)
LIBGTK2_DEPENDENCIES += xlib_libXcursor
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFIXES),y)
LIBGTK2_DEPENDENCIES += xlib_libXfixes
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCOMPOSITE),y)
LIBGTK2_DEPENDENCIES += xlib_libXcomposite
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXDAMAGE),y)
LIBGTK2_DEPENDENCIES += xlib_libXdamage
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
LIBGTK2_DEPENDENCIES += libpng
else
LIBGTK2_CONF_OPTS += --without-libpng
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
LIBGTK2_DEPENDENCIES += jpeg
else
LIBGTK2_CONF_OPTS += --without-libjpeg
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
LIBGTK2_DEPENDENCIES += tiff
else
LIBGTK2_CONF_OPTS += --without-libtiff
endif

ifeq ($(BR2_PACKAGE_CUPS),y)
LIBGTK2_CONF_OPTS += CUPS_CONFIG="$(STAGING_DIR)/usr/bin/cups-config"
LIBGTK2_DEPENDENCIES += cups
else
LIBGTK2_CONF_OPTS += --disable-cups
endif

ifeq ($(BR2_PACKAGE_LIBGTK2_DEMO),)
define LIBGTK2_POST_INSTALL_TWEAKS
	rm -rf $(TARGET_DIR)/usr/share/gtk-2.0/demo $(TARGET_DIR)/usr/bin/gtk-demo
endef

LIBGTK2_POST_INSTALL_TARGET_HOOKS += LIBGTK2_POST_INSTALL_TWEAKS
endif

# We do not build a full version of libgtk2 for the host, because that
# requires compiling Cairo, Pango, ATK and X.org for the
# host. Therefore, we patch it to remove dependencies, and we hack the
# build to only build gdk-pixbuf-from-source and
# gtk-update-icon-cache, which are the host tools needed to build Gtk
# for the target.

HOST_LIBGTK2_DEPENDENCIES = host-libglib2 host-libpng host-gdk-pixbuf
HOST_LIBGTK2_CONF_OPTS = \
	--disable-static \
	--disable-glibtest \
	--without-libtiff \
	--without-libjpeg \
	--with-gdktarget=none \
	--disable-cups

define HOST_LIBGTK2_BUILD_CMDS
	$(HOST_MAKE_ENV) make -C $(@D)/gtk gtk-update-icon-cache
endef

define HOST_LIBGTK2_INSTALL_CMDS
	cp $(@D)/gtk/gtk-update-icon-cache $(HOST_DIR)/usr/bin
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))
