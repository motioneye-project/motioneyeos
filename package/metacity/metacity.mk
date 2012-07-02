#############################################################
#
# metacity
#
#############################################################

# newer versions need libcanberra-gtk and gnome-doc-utils
METACITY_VERSION_MAJOR = 2.25
METACITY_VERSION_MINOR = 1
METACITY_VERSION = $(METACITY_VERSION_MAJOR).$(METACITY_VERSION_MINOR)
METACITY_SOURCE = metacity-$(METACITY_VERSION).tar.bz2
METACITY_SITE = http://ftp.gnome.org/pub/gnome/sources/metacity/$(METACITY_VERSION_MAJOR)

METACITY_CONF_OPT = --x-includes=$(STAGING_DIR)/usr/include/X11 \
		--x-libraries=$(STAGING_DIR)/usr/lib \
		--disable-glibtest --disable-gconf \
		--disable-dependency-tracking \
		--disable-sm --disable-startup-notification

METACITY_DEPENDENCIES = libgtk2 xserver_xorg-server

define METACITY_INSTALL_XSESSION
	install -D package/metacity/Xsession $(TARGET_DIR)/etc/X11/Xsession
endef

METACITY_POST_INSTALL_TARGET_HOOKS += METACITY_INSTALL_XSESSION

$(eval $(autotools-package))
