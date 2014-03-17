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

METACITY_CONF_OPT = --x-includes=$(STAGING_DIR)/usr/include/X11 \
		--x-libraries=$(STAGING_DIR)/usr/lib \
		--disable-glibtest --disable-gconf \
		--disable-dependency-tracking \
		--disable-sm --disable-startup-notification

METACITY_DEPENDENCIES = libgtk2 \
	xlib_libX11 \
	host-perl-xml-parser \
	xlib_libXcomposite \
	xlib_libXfixes \
	xlib_libXrender \
	xlib_libXdamage

ifeq ($(BR2_PACKAGE_XLIB_LIBXCURSOR),y)
METACITY_DEPENDENCIES += xlib_libXcursor
endif

define METACITY_INSTALL_XSESSION
	install -D package/metacity/Xsession $(TARGET_DIR)/etc/X11/Xsession
endef

METACITY_POST_INSTALL_TARGET_HOOKS += METACITY_INSTALL_XSESSION

$(eval $(autotools-package))
