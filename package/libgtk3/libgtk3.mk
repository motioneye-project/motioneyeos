################################################################################
#
# libgtk3
#
################################################################################

LIBGTK3_VERSION_MAJOR = 3.14
LIBGTK3_VERSION = $(LIBGTK3_VERSION_MAJOR).5
LIBGTK3_SOURCE = gtk+-$(LIBGTK3_VERSION).tar.xz
LIBGTK3_SITE = http://ftp.gnome.org/pub/gnome/sources/gtk+/$(LIBGTK3_VERSION_MAJOR)
LIBGTK3_LICENSE = LGPLv2+
LIBGTK3_LICENSE_FILES = COPYING
LIBGTK3_INSTALL_STAGING = YES
LIBGTK3_AUTORECONF = YES

LIBGTK3_CONF_ENV = \
	ac_cv_path_GTK_UPDATE_ICON_CACHE=$(HOST_DIR)/usr/bin/gtk-update-icon-cache \
	ac_cv_path_GDK_PIXBUF_CSOURCE=$(HOST_DIR)/usr/bin/gdk-pixbuf-csource \
	PKG_CONFIG_FOR_BUILD=$(HOST_DIR)/usr/bin/pkgconf

LIBGTK3_CONF_OPTS = \
	--disable-glibtest \
	--enable-explicit-deps=no \
	--enable-gtk2-dependency \
	--disable-introspection

LIBGTK3_DEPENDENCIES = host-pkgconf host-libgtk3 atk libglib2 cairo pango gdk-pixbuf

ifeq ($(BR2_PACKAGE_LIBGTK3_X11),y)
LIBGTK3_DEPENDENCIES += fontconfig xlib_libX11 xlib_libXext xlib_libXrender xlib_libXi

LIBGTK3_CONF_OPTS += \
	--enable-x11-backend \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib
else
LIBGTK3_CONF_OPTS += --disable-x11-backend
endif

ifeq ($(BR2_PACKAGE_LIBGTK3_WAYLAND),y)
LIBGTK3_DEPENDENCIES += wayland libxkbcommon
LIBGTK3_CONF_OPTS += --enable-wayland-backend
else
LIBGTK3_CONF_OPTS += --disable-wayland-backend
endif

ifeq ($(BR2_PACKAGE_LIBGTK3_BROADWAY),y)
LIBGTK3_CONF_OPTS += --enable-broadway-backend
else
LIBGTK3_CONF_OPTS += --disable-broadway-backend
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
LIBGTK3_CONF_OPTS += --enable-xinerama
LIBGTK3_DEPENDENCIES += xlib_libXinerama
else
LIBGTK3_CONF_OPTS += --disable-xinerama
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
LIBGTK3_CONF_OPTS += --enable-xrandr
LIBGTK3_DEPENDENCIES += xlib_libXrandr
else
LIBGTK3_CONF_OPTS += --disable-xrandr
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCURSOR),y)
LIBGTK3_DEPENDENCIES += xlib_libXcursor
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFIXES),y)
LIBGTK3_CONF_OPTS += --enable-xfixes
LIBGTK3_DEPENDENCIES += xlib_libXfixes
else
LIBGTK3_CONF_OPTS += --disable-xfixes
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCOMPOSITE),y)
LIBGTK3_CONF_OPTS += --enable-xcomposite
LIBGTK3_DEPENDENCIES += xlib_libXcomposite
else
LIBGTK3_CONF_OPTS += --disable-xcomposite
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXDAMAGE),y)
LIBGTK3_CONF_OPTS += --enable-xdamage
LIBGTK3_DEPENDENCIES += xlib_libXdamage
else
LIBGTK3_CONF_OPTS += --disable-xdamage
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXKBFILE),y)
LIBGTK3_CONF_OPTS += --enable-xkb
LIBGTK3_DEPENDENCIES += xlib_libxkbfile
else
LIBGTK3_CONF_OPTS += --disable-xkb
endif

ifeq ($(BR2_PACKAGE_CUPS),y)
LIBGTK3_CONF_OPTS += --enable-cups
LIBGTK3_CONF_ENV += ac_cv_path_CUPS_CONFIG=$(STAGING_DIR)/usr/bin/cups-config
LIBGTK3_DEPENDENCIES += cups
else
LIBGTK3_CONF_OPTS += --disable-cups
endif

ifeq ($(BR2_PACKAGE_LIBGTK3_DEMO),y)
LIBGTK3_DEPENDENCIES += hicolor-icon-theme shared-mime-info
else
define LIBGTK3_REMOVE_DEMOS
	$(RM) $(TARGET_DIR)/usr/bin/gtk3-demo \
		$(TARGET_DIR)/usr/bin/gtk3-demo-application
endef
LIBGTK3_POST_INSTALL_TARGET_HOOKS += LIBGTK3_REMOVE_DEMOS
endif

ifeq ($(BR2_PACKAGE_LIBGTK3_TESTS),y)
LIBGTK3_CONF_OPTS += --enable-installed-tests
else
LIBGTK3_CONF_OPTS += --disable-installed-tests
endif

define LIBGTK3_COMPILE_GLIB_SCHEMAS
	$(HOST_DIR)/usr/bin/glib-compile-schemas \
		$(TARGET_DIR)/usr/share/glib-2.0/schemas
endef

LIBGTK3_POST_INSTALL_TARGET_HOOKS += LIBGTK3_COMPILE_GLIB_SCHEMAS

# gtk+ >= 3.10 can build a native version of gtk-update-icon-cache if
# --enable-gtk2-dependency=no is set when invoking './configure'.
#
# Unfortunately, if the target toolchain is based on uClibc, the macro
# AM_GLIB_GNU_GETTEXT will detect the libintl built for the target and
# will add '-lintl' to the default list of libraries for the linker (used
# for both native and target builds).
#
# But no native version of libintl is available (the functions are
# provided by glibc). So gtk-update-icon-cache will not build, and
# extract-strings neither.
#
# As a workaround, we build gtk-update-icon-cache on our own, set
# --enable-gtk2-dependency=yes and force './configure' to use our version.

HOST_LIBGTK3_DEPENDENCIES = \
	host-libglib2 \
	host-libpng \
	host-gdk-pixbuf \
	host-pkgconf

HOST_LIBGTK3_CFLAGS = \
	$(shell $(HOST_DIR)/usr/bin/pkgconf \
	--cflags --libs gdk-pixbuf-2.0)

define HOST_LIBGTK3_CONFIGURE_CMDS
	echo "#define GETTEXT_PACKAGE \"gtk30\"" >> $(@D)/gtk/config.h
	echo "#define HAVE_UNISTD_H 1" >> $(@D)/gtk/config.h
	echo "#define HAVE_FTW_H 1" >> $(@D)/gtk/config.h
endef

define HOST_LIBGTK3_BUILD_CMDS
	$(HOSTCC) $(HOST_CFLAGS) $(HOST_LDFLAGS) \
		$(@D)/gtk/updateiconcache.c \
		$(HOST_LIBGTK3_CFLAGS) \
		-o $(@D)/gtk/gtk-update-icon-cache
	$(HOSTCC) $(HOST_CFLAGS) $(HOST_LDFLAGS) \
		$(@D)/util/extract-strings.c \
		$(HOST_LIBGTK3_CFLAGS) \
		-o $(@D)/util/extract-strings
endef

define HOST_LIBGTK3_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/gtk/gtk-update-icon-cache \
		$(HOST_DIR)/usr/bin/gtk-update-icon-cache
	$(INSTALL) -D -m 0755 $(@D)/util/extract-strings \
		$(HOST_DIR)/usr/bin/extract-strings
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))
