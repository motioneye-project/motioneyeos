#############################################################
#
# webkit
#
#############################################################
WEBKIT_VERSION = r31321
WEBKIT_SOURCE = WebKit-$(WEBKIT_VERSION).tar.bz2
WEBKIT_SITE = http://nightly.webkit.org/files/trunk/src/

WEBKIT_INSTALL_STAGING = YES
WEBKIT_INSTALL_TARGET = YES
WEBKIT_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) install

WEBKIT_AUTORECONF = YES
WEBKIT_DEPENDENCIES = icu curl libxml2 libxslt libgtk2 sqlite

$(eval $(call AUTOTARGETS,package,webkit))
