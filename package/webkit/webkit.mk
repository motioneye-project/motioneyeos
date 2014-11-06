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

WEBKIT_DEPENDENCIES += \
	$(if $(BR_PACKAGE_XLIB_LIBXCOMPOSITE),xlib_libXcomposite) \
	$(if $(BR_PACKAGE_XLIB_LIBXDAMAGE),xlib_libXdamage)

# webkit-disable-tests.patch changes configure.ac therefore autoreconf required
WEBKIT_AUTORECONF = YES
WEBKIT_AUTORECONF_OPTS = -I $(@D)/Source/autotools

# parallel make install deadlocks with make 3.81
WEBKIT_INSTALL_STAGING_OPTS = -j1 DESTDIR=$(STAGING_DIR) install
WEBKIT_INSTALL_TARGET_OPTS = -j1 DESTDIR=$(TARGET_DIR) install

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

WEBKIT_CONF_OPTS += \
	--enable-dependency-tracking \
	--with-gtk=2.0 \
	--disable-geolocation \
	--disable-webkit2 \
	--disable-glibtest \
	--disable-video \
	--disable-gtk-doc-html \
	--disable-tests

# Xorg Dependencies
WEBKIT_CONF_OPTS += --with-target=x11
WEBKIT_DEPENDENCIES += xlib_libXt

ifeq ($(BR2_PACKAGE_HAS_LIBEGL)$(BR2_PACKAGE_HAS_LIBGLES),yy)
WEBKIT_CONF_OPTS += --enable-gles2
WEBKIT_DEPENDENCIES += libegl libgles
else
WEBKIT_CONF_OPTS += --disable-gles2
endif

# gles/egl support is prefered over opengl by webkit configure
ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
WEBKIT_CONF_OPTS += --with-acceleration-backend=opengl
WEBKIT_DEPENDENCIES += libgl
else
# OpenGL/glx is auto-detected due to the presence of gl.h/glx.h, which is not
# enough, so disable glx and the use of the OpenGL acceleration backend here
WEBKIT_CONF_OPTS += --disable-glx --with-acceleration-backend=none
endif

$(eval $(autotools-package))
