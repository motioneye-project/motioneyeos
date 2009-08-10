#############################################################
#
# webkit
#
#############################################################
WEBKIT_VERSION = r44552
WEBKIT_SOURCE = WebKit-$(WEBKIT_VERSION).tar.bz2
WEBKIT_SITE = http://nightly.webkit.org/files/trunk/src/

WEBKIT_INSTALL_STAGING = YES
WEBKIT_INSTALL_TARGET = YES
WEBKIT_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) install
WEBKIT_LIBTOOL_PATCH = NO

WEBKIT_DEPENDENCIES = icu curl libxml2 libxslt libgtk2 sqlite enchant \
			libsoup

ifeq ($(BR2_PACKAGE_WEBKIT_X11),y)
WEBKIT_CONF_OPT = --with-target=x11
endif

ifeq ($(BR2_PACKAGE_WEBKIT_DIRECTFB),y)
WEBKIT_CONF_OPT = --with-target=directfb
endif

WEBKIT_CONF_OPT += --disable-video

$(eval $(call AUTOTARGETS,package,webkit))

$(WEBKIT_HOOK_POST_EXTRACT):
	$(SED) 's/AUTOMAKE_FLAGS=.*/AUTOMAKE_FLAGS="--foreign --add-missing --copy"/' $(WEBKIT_DIR)/autogen.sh
	$(SED) 's/LIBTOOLIZE_FLAGS=.*/LIBTOOLIZE_FLAGS="--force --automake --copy"/' $(WEBKIT_DIR)/autogen.sh
	# Don't run the configure step yet
	cd $(WEBKIT_DIR); AUTOGEN_CONFIGURE_ARGS=--version ./autogen.sh
	touch $@
