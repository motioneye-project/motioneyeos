################################################################################
#
# webkit
#
################################################################################

WEBKIT_VERSION = 1.11.5
WEBKIT_SITE = http://www.webkitgtk.org/releases
WEBKIT_SOURCE = webkitgtk-$(WEBKIT_VERSION).tar.xz
WEBKIT_INSTALL_STAGING = YES
WEBKIT_DEPENDENCIES = host-ruby host-flex host-bison host-gperf enchant harfbuzz \
	icu jpeg libcurl libgail libsecret libsoup libxml2 libxslt libgtk2 sqlite webp

# webkit-disable-tests.patch changes configure.ac therefore autoreconf required
WEBKIT_AUTORECONF = YES
WEBKIT_AUTORECONF_OPT = -I $(@D)/Source/autotools

# parallel make install deadlocks with make 3.81
WEBKIT_INSTALL_STAGING_OPT = -j1 DESTDIR=$(STAGING_DIR) install
WEBKIT_INSTALL_TARGET_OPT = -j1 DESTDIR=$(TARGET_DIR) install

# Does not build and it's disabled by default
# in newer releases
define DISABLE_INDEXED_DATABASE
	$(SED) '/ENABLE_INDEXED_DATABASE/s:1:0:' \
			$(@D)/Source/WebCore/GNUmakefile.features.am
endef

WEBKIT_PRE_CONFIGURE_HOOKS += DISABLE_INDEXED_DATABASE

# Give explicit path to icu-config, and silence gazillions of warnings
# with recent gcc versions.
WEBKIT_CONF_ENV = ac_cv_path_icu_config=$(STAGING_DIR)/usr/bin/icu-config \
	CFLAGS="$(TARGET_CFLAGS) -Wno-cast-align -Wno-sign-compare" \
	CXXFLAGS="$(TARGET_CXXFLAGS) -Wno-cast-align -Wno-sign-compare" \
	AR_FLAGS="cru"

WEBKIT_CONF_OPT += \
	--with-gtk=2.0 \
	--disable-geolocation \
	--disable-webkit2 \
	--disable-glibtest \
	--disable-video \
	--disable-gtk-doc-html \
	--disable-tests

# Xorg Dependencies
WEBKIT_CONF_OPT += --with-target=x11
WEBKIT_DEPENDENCIES += xlib_libXt

$(eval $(autotools-package))
