#############################################################
#
# webkit
#
#############################################################

WEBKIT_VERSION = 1.2.7
WEBKIT_SITE = http://www.webkitgtk.org
WEBKIT_INSTALL_STAGING = YES
WEBKIT_DEPENDENCIES = host-flex host-bison host-gperf icu libcurl libxml2 \
	libxslt libgtk2 sqlite enchant libsoup jpeg libgail

# Give explicit path to icu-config, and silence gazillions of warnings
# with recent gcc versions.
WEBKIT_CONF_ENV = ac_cv_path_icu_config=$(STAGING_DIR)/usr/bin/icu-config \
	CFLAGS="$(TARGET_CFLAGS) -Wno-cast-align" \
	CXXFLAGS="$(TARGET_CXXFLAGS) -Wno-cast-align"


ifeq ($(BR2_PACKAGE_XORG7),y)
	WEBKIT_CONF_OPT += --with-target=x11
	WEBKIT_DEPENDENCIES += xlib_libXt
else
	WEBKIT_CONF_OPT += --with-target=directfb
	WEBKIT_DEPENDENCIES += directfb
endif

WEBKIT_CONF_OPT += --disable-video

$(eval $(autotools-package))
