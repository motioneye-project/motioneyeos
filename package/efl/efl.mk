################################################################################
#
# efl
#
################################################################################

EFL_VERSION = 1.18.4
EFL_SOURCE = efl-$(EFL_VERSION).tar.xz
EFL_SITE = http://download.enlightenment.org/rel/libs/efl
EFL_LICENSE = BSD-2c, LGPLv2.1+, GPLv2+
EFL_LICENSE_FILES = \
	COMPLIANCE \
	COPYING \
	licenses/COPYING.BSD \
	licenses/COPYING.FTL \
	licenses/COPYING.GPL \
	licenses/COPYING.LGPL \
	licenses/COPYING.SMALL

EFL_INSTALL_STAGING = YES

EFL_DEPENDENCIES = host-pkgconf host-efl host-luajit dbus freetype \
	jpeg luajit lz4 zlib

# Configure options:
# --disable-lua-old: build elua for the target.
# --disable-poppler: disable poppler image loader.
# --disable-sdl: disable sdl2 support.
# --disable-spectre: disable spectre image loader.
# --disable-xinput22: disable X11 XInput v2.2+ support.
# --enable-liblz4: use liblz4 from lz4 package.
# --with-doxygen: disable doxygen documentation
EFL_CONF_OPTS = \
	--with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
	--with-eet-eet=$(HOST_DIR)/usr/bin/eet \
	--with-eldbus_codegen=$(HOST_DIR)/usr/bin/eldbus-codegen \
	--with-elementary-codegen=$(HOST_DIR)/usr/bin/elementary_codegen \
	--with-elm-prefs-cc=$(HOST_DIR)/usr/bin/elm_prefs_cc \
	--with-elua=$(HOST_DIR)/usr/bin/elua \
	--with-eolian-gen=$(HOST_DIR)/usr/bin/eolian_gen \
	--disable-image-loader-jp2k \
	--disable-lua-old \
	--disable-poppler \
	--disable-sdl \
	--disable-spectre \
	--disable-xinput22 \
	--disable-wayland \
	--enable-liblz4 \
	--with-doxygen=no

# Disable untested configuration warning.
ifeq ($(BR2_PACKAGE_EFL_HAS_RECOMMENDED_CONFIG),)
EFL_CONF_OPTS += --enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-abb
endif

ifeq ($(BR2_PACKAGE_EFL_EOLIAN_CPP),y)
EFL_CONF_OPTS += --enable-cxx-bindings \
	--with-eolian-cxx=$(HOST_DIR)/usr/bin/eolian_cxx
else
EFL_CONF_OPTS += --disable-cxx-bindings
endif

ifeq ($(BR2_PACKAGE_EFL_EEZE),y)
EFL_DEPENDENCIES += udev
EFL_CONF_OPTS += --enable-libeeze
else
EFL_CONF_OPTS += --disable-libeeze
endif

ifeq ($(BR2_PACKAGE_EFL_UTIL_LINUX_LIBMOUNT),y)
EFL_DEPENDENCIES += util-linux
EFL_CONF_OPTS += --enable-libmount
else
EFL_CONF_OPTS += --disable-libmount
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
EFL_CONF_OPTS += --enable-systemd
EFL_DEPENDENCIES += systemd
else
EFL_CONF_OPTS += --disable-systemd
endif

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
EFL_CONF_OPTS += --enable-fontconfig
EFL_DEPENDENCIES += fontconfig
else
EFL_CONF_OPTS += --disable-fontconfig
endif

ifeq ($(BR2_PACKAGE_LIBFRIBIDI),y)
EFL_CONF_OPTS += --enable-fribidi
EFL_DEPENDENCIES += libfribidi
else
EFL_CONF_OPTS += --disable-fribidi
endif

ifeq ($(BR2_PACKAGE_GSTREAMER1)$(BR2_PACKAGE_GST1_PLUGINS_BASE),yy)
EFL_CONF_OPTS += --enable-gstreamer1
EFL_DEPENDENCIES += gstreamer1 gst1-plugins-base
else
EFL_CONF_OPTS += --disable-gstreamer1
endif

ifeq ($(BR2_PACKAGE_BULLET),y)
EFL_CONF_OPTS += --enable-physics
EFL_DEPENDENCIES += bullet
else
EFL_CONF_OPTS += --disable-physics
endif

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
EFL_CONF_OPTS += --enable-audio
EFL_DEPENDENCIES += libsndfile
else
EFL_CONF_OPTS += --disable-audio
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
EFL_CONF_OPTS += --enable-pulseaudio
EFL_DEPENDENCIES += pulseaudio
else
EFL_CONF_OPTS += --disable-pulseaudio
endif

ifeq ($(BR2_PACKAGE_HARFBUZZ),y)
EFL_DEPENDENCIES += harfbuzz
EFL_CONF_OPTS += --enable-harfbuzz
else
EFL_CONF_OPTS += --disable-harfbuzz
endif

ifeq ($(BR2_PACKAGE_TSLIB),y)
EFL_DEPENDENCIES += tslib
EFL_CONF_OPTS += --enable-tslib
else
EFL_CONF_OPTS += --disable-tslib
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
EFL_DEPENDENCIES += libglib2
EFL_CONF_OPTS += --with-glib=yes
else
EFL_CONF_OPTS += --with-glib=no
endif

# Prefer openssl (the default) over gnutls.
ifeq ($(BR2_PACKAGE_OPENSSL),y)
EFL_DEPENDENCIES += openssl
EFL_CONF_OPTS += --with-crypto=openssl
else ifeq ($(BR2_PACKAGE_GNUTLS)$(BR2_PACKAGE_LIBGCRYPT),yy)
EFL_DEPENDENCIES += gnutls libgcrypt
EFL_CONF_OPTS += --with-crypto=gnutls \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
EFL_CONF_OPTS += --with-crypto=none
endif # BR2_PACKAGE_OPENSSL

ifeq ($(BR2_PACKAGE_EFL_ELPUT),y)
EFL_CONF_OPTS += --enable-elput
EFL_DEPENDENCIES += libinput
else
EFL_CONF_OPTS += --disable-elput
endif

ifeq ($(BR2_PACKAGE_EFL_FB),y)
EFL_CONF_OPTS += --enable-fb
else
EFL_CONF_OPTS += --disable-fb
endif

ifeq ($(BR2_PACKAGE_EFL_X_XLIB),y)
EFL_CONF_OPTS += \
	--with-x11=xlib \
	--with-x=$(STAGING_DIR) \
	--x-includes=$(STAGING_DIR)/usr/include \
	--x-libraries=$(STAGING_DIR)/usr/lib

EFL_DEPENDENCIES += \
	xlib_libX11 \
	xlib_libXcomposite \
	xlib_libXcursor \
	xlib_libXdamage \
	xlib_libXext \
	xlib_libXinerama \
	xlib_libXrandr \
	xlib_libXrender \
	xlib_libXScrnSaver \
	xlib_libXtst
else
EFL_CONF_OPTS += --with-x11=none
endif

ifeq ($(BR2_PACKAGE_EFL_OPENGL),y)
EFL_CONF_OPTS += --with-opengl=full
EFL_DEPENDENCIES += libgl
# OpenGL ES requires EGL
else ifeq ($(BR2_PACKAGE_EFL_OPENGLES),y)
EFL_CONF_OPTS += --with-opengl=es --enable-egl
EFL_DEPENDENCIES += libegl libgles
else ifeq ($(BR2_PACKAGE_EFL_OPENGL_NONE),y)
EFL_CONF_OPTS += --with-opengl=none
endif

ifeq ($(BR2_PACKAGE_EFL_DRM),y)
EFL_CONF_OPTS += --enable-drm
EFL_DEPENDENCIES += libdrm libegl mesa3d
else
EFL_CONF_OPTS += --disable-drm
endif

# The EFL Wayland support requires Evas GLES DRM engine support
# which depends on wayland-client to build.
# So enable gl_drm only when wayland support is selected.
ifeq ($(BR2_PACKAGE_EFL_WAYLAND),y)
EFL_DEPENDENCIES += wayland
EFL_CONF_OPTS += --enable-wayland --enable-gl-drm
else
EFL_CONF_OPTS += --disable-wayland --disable-gl-drm
endif

EFL_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBXKBCOMMON),libxkbcommon)

# Loaders that need external dependencies needs to be --enable-XXX=yes
# otherwise the default is '=static'.
# All other loaders are statically built-in
ifeq ($(BR2_PACKAGE_EFL_PNG),y)
EFL_CONF_OPTS += --enable-image-loader-png=yes
EFL_DEPENDENCIES += libpng
else
EFL_CONF_OPTS += --disable-image-loader-png
endif

ifeq ($(BR2_PACKAGE_EFL_JPEG),y)
EFL_CONF_OPTS += --enable-image-loader-jpeg=yes
# efl already depends on jpeg.
else
EFL_CONF_OPTS += --disable-image-loader-jpeg
endif

ifeq ($(BR2_PACKAGE_EFL_GIF),y)
EFL_CONF_OPTS += --enable-image-loader-gif=yes
EFL_DEPENDENCIES += giflib
else
EFL_CONF_OPTS += --disable-image-loader-gif
endif

ifeq ($(BR2_PACKAGE_EFL_TIFF),y)
EFL_CONF_OPTS += --enable-image-loader-tiff=yes
EFL_DEPENDENCIES += tiff
else
EFL_CONF_OPTS += --disable-image-loader-tiff
endif

ifeq ($(BR2_PACKAGE_EFL_WEBP),y)
EFL_CONF_OPTS += --enable-image-loader-webp=yes
EFL_DEPENDENCIES += webp
else
EFL_CONF_OPTS += --disable-image-loader-webp
endif

ifeq ($(BR2_PACKAGE_EFL_LIBRAW),y)
EFL_DEPENDENCIES += libraw
EFL_CONF_OPTS += --enable-libraw
else
EFL_CONF_OPTS += --disable-libraw
endif

ifeq ($(BR2_PACKAGE_EFL_SVG),y)
EFL_DEPENDENCIES += librsvg cairo
EFL_CONF_OPTS += --enable-librsvg
else
EFL_CONF_OPTS += --disable-librsvg
endif

ifeq ($(BR2_PACKAGE_UPOWER),)
# upower ecore system module is only useful if upower
# dbus service is available.
# It's not essential, only used to notify applications
# of power state, such as low battery or AC power, so
# they can adapt their power consumption.
define EFL_HOOK_REMOVE_UPOWER
	rm -fr $(TARGET_DIR)/usr/lib/ecore/system/upower
endef
EFL_POST_INSTALL_TARGET_HOOKS = EFL_HOOK_REMOVE_UPOWER
endif

$(eval $(autotools-package))

################################################################################
#
# host-efl
#
################################################################################

# We want to build only some host tools used later in the build.
# Actually we want: edje_cc, eet and embryo_cc. eolian_cxx is built only
# if selected for the target.

# Host dependencies:
# * host-dbus: for Eldbus
# * host-freetype: for libevas
# * host-libglib2: for libecore
# * host-libjpeg, host-libpng: for libevas image loader
# * host-luajit for Elua tool for the host
HOST_EFL_DEPENDENCIES = \
	host-pkgconf \
	host-dbus \
	host-freetype \
	host-libglib2 \
	host-libjpeg \
	host-libpng \
	host-luajit \
	host-zlib

# Configure options:
# --disable-audio, --disable-multisense remove libsndfile dependency.
# --disable-fontconfig: remove dependency on fontconfig.
# --disable-fribidi: remove dependency on libfribidi.
# --disable-gstreamer1: remove dependency on gtreamer 1.0.
# --disable-libeeze: remove libudev dependency.
# --disable-libmount: remove dependency on host-util-linux libmount.
# --disable-lua-old: build elua for the host.
# --disable-physics: remove Bullet dependency.
# --disable-poppler: disable poppler image loader.
# --disable-spectre: disable spectre image loader.
# --enable-image-loader-gif=no: disable Gif dependency.
# --enable-image-loader-tiff=no: disable Tiff dependency.
# --with-crypto=none: remove dependencies on openssl or gnutls.
# --with-doxygen: disable doxygen documentation
# --with-x11=none: remove dependency on X.org.
#   Yes I really know what I am doing.
HOST_EFL_CONF_OPTS += \
	--disable-audio \
	--disable-fontconfig \
	--disable-fribidi \
	--disable-gstreamer1 \
	--disable-libeeze \
	--disable-libmount \
	--disable-libraw \
	--disable-librsvg \
	--disable-lua-old \
	--disable-multisense \
	--disable-physics \
	--disable-poppler \
	--disable-spectre \
	--disable-xcf \
	--enable-image-loader-gif=no \
	--enable-image-loader-jpeg=yes \
	--enable-image-loader-png=yes \
	--enable-image-loader-tiff=no \
	--with-crypto=none \
	--with-doxygen=no \
	--with-glib=yes \
	--with-opengl=none \
	--with-x11=none \
	--enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-abb

# Enable Eolian language bindings to provide eolian_cxx tool for the
# host which is required to build Eolian language bindings for the
# target.
ifeq ($(BR2_PACKAGE_EFL_EOLIAN_CPP),y)
HOST_EFL_CONF_OPTS += --enable-cxx-bindings
else
HOST_EFL_CONF_OPTS += --disable-cxx-bindings
endif

# Always disable upower system module from host as it's
# not useful and would try to use the output/host/var
# system bus which is non-existent and does not contain
# any upower service in it.
define HOST_EFL_HOOK_REMOVE_UPOWER
	rm -fr $(HOST_DIR)/usr/lib/ecore/system/upower
endef
HOST_EFL_POST_INSTALL_HOOKS = HOST_EFL_HOOK_REMOVE_UPOWER

$(eval $(host-autotools-package))
