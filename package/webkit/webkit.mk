#############################################################
#
# webkit
#
#############################################################
WEBKIT_VERSION = r30574
WEBKIT_SOURCE = WebKit-$(WEBKIT_VERSION).tar.bz2
WEBKIT_SITE = http://nightly.webkit.org/files/trunk/src/

WEBKIT_INSTALL_STAGING = YES
WEBKIT_INSTALL_TARGET = YES
WEBKIT_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) install 

WEBKIT_AUTORECONF = YES
WEBKIT_DEPENDENCIES = icu curl libxml2 libxslt xserver_xorg-server libgtk2 sqlite
WEBKIT_MAKE_OPT = GLIB_GENMARSHAL=/usr/bin/glib-genmarshal GLIB_MKENUMS=/usr/bin/glib-mkenums

$(eval $(call AUTOTARGETS,package,webkit))

