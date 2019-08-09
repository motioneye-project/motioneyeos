################################################################################
#
# metacity
#
################################################################################

# newer versions need libcanberra-gtk and gnome-doc-utils
METACITY_VERSION_MAJOR = 2.25
METACITY_VERSION = $(METACITY_VERSION_MAJOR).1
METACITY_SOURCE = metacity-$(METACITY_VERSION).tar.bz2
METACITY_SITE = http://ftp.gnome.org/pub/gnome/sources/metacity/$(METACITY_VERSION_MAJOR)
METACITY_LICENSE = GPL-2.0+
METACITY_LICENSE_FILES = COPYING

METACITY_CONF_OPTS = \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib \
	--disable-glibtest \
	--disable-gconf \
	--disable-sm \
	--disable-startup-notification

METACITY_DEPENDENCIES = libgtk2 \
	xlib_libX11 \
	host-libxml-parser-perl \
	xlib_libXcomposite \
	xlib_libXfixes \
	xlib_libXrender \
	xlib_libXdamage \
	$(TARGET_NLS_DEPENDENCIES)

METACITY_CONF_ENV = LIBS=$(TARGET_NLS_LIBS)

ifeq ($(BR2_PACKAGE_XLIB_LIBXCURSOR),y)
METACITY_DEPENDENCIES += xlib_libXcursor
endif

define METACITY_INSTALL_XSESSION
	$(INSTALL) -D package/metacity/Xsession $(TARGET_DIR)/etc/X11/Xsession
endef

METACITY_POST_INSTALL_TARGET_HOOKS += METACITY_INSTALL_XSESSION

$(eval $(autotools-package))
