#############################################################
#
# metacity
#
#############################################################

METACITY_VERSION = 2.16.8
METACITY_SOURCE = metacity-$(METACITY_VERSION).tar.bz2
METACITY_SITE = http://ftp.gnome.org/pub/gnome/sources/metacity/2.16
METACITY_INSTALL_STAGING =NO
METACITY_INSTALL_TARGET =YES

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

$(eval $(call AUTOTARGETS,package,metacity))
