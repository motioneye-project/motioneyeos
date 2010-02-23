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
WEBKIT_LIBTOOL_PATCH = NO

WEBKIT_DEPENDENCIES = host-flex host-gperf icu curl libxml2 libxslt	\
			libgtk2 sqlite enchant libsoup

ifeq ($(BR2_PACKAGE_WEBKIT_X11),y)
WEBKIT_CONF_OPT = --with-target=x11
endif

ifeq ($(BR2_PACKAGE_WEBKIT_DIRECTFB),y)
WEBKIT_CONF_OPT = --with-target=directfb
endif

WEBKIT_CONF_OPT += --disable-video

define WEBKIT_AUTOGEN_PATCH
$(SED) 's%ACLOCAL_FLAGS=.*%ACLOCAL_FLAGS="-I autotools -I $(STAGING_DIR)/usr/share/aclocal"%' $(WEBKIT_DIR)/autogen.sh
$(SED) 's/AUTOMAKE_FLAGS=.*/AUTOMAKE_FLAGS="--foreign --add-missing --copy"/' $(WEBKIT_DIR)/autogen.sh
$(SED) 's/LIBTOOLIZE_FLAGS=.*/LIBTOOLIZE_FLAGS="--force --automake --copy"/' $(WEBKIT_DIR)/autogen.sh
cp package/webkit/gtk-doc.make $(WEBKIT_DIR)/
# Don't run the configure step yet
cd $(WEBKIT_DIR); $(HOST_CONFIGURE_OPTS) AUTOGEN_CONFIGURE_ARGS=--version ./autogen.sh
endef

WEBKIT_POST_EXTRACT_HOOKS += WEBKIT_AUTOGEN_PATCH

$(eval $(call AUTOTARGETS,package,webkit))
