################################################################################
#
# webkit
#
################################################################################

WEBKIT_VERSION = 1.9.6
WEBKIT_SITE = http://www.webkitgtk.org/releases
WEBKIT_SOURCE = webkit-$(WEBKIT_VERSION).tar.xz
WEBKIT_INSTALL_STAGING = YES
WEBKIT_DEPENDENCIES = host-ruby host-flex host-bison host-gperf icu libcurl \
	libxml2 libxslt libgtk2 sqlite enchant libsoup jpeg libgail

# webkit-disable-tests.patch changes configure.ac therefore autoreconf required
WEBKIT_AUTORECONF = YES
WEBKIT_AUTORECONF_OPT = -I $(@D)/Source/autotools

# Give explicit path to icu-config, and silence gazillions of warnings
# with recent gcc versions.
WEBKIT_CONF_ENV = ac_cv_path_icu_config=$(STAGING_DIR)/usr/bin/icu-config \
	CFLAGS="$(TARGET_CFLAGS) -Wno-cast-align -Wno-sign-compare" \
	CXXFLAGS="$(TARGET_CXXFLAGS) -Wno-cast-align -Wno-sign-compare"

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
