################################################################################
#
# efl
#
################################################################################

EFL_VERSION = 1.17.2
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
	jpeg luajit udev util-linux zlib

# Configure options:
# --disable-lua-old: build elua for the target.
# --disable-sdl: disable sdl2 support.
# --disable-xinput22: disable X11 XInput v2.2+ support.
# --with-opengl=none: disable opengl support.
EFL_CONF_OPTS = \
	--with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
	--with-elua=$(HOST_DIR)/usr/bin/elua \
	--with-eolian-gen=$(HOST_DIR)/usr/bin/eolian_gen \
	--disable-lua-old \
	--disable-sdl \
	--disable-xinput22 \
	--with-opengl=none

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

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBMOUNT),y)
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

ifeq ($(BR2_PACKAGE_WAYLAND),y)
EFL_DEPENDENCIES += wayland libxkbcommon
EFL_CONF_OPTS += --enable-wayland
else
EFL_CONF_OPTS += --disable-wayland
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

ifeq ($(BR2_PACKAGE_EFL_JP2K),y)
EFL_CONF_OPTS += --enable-image-loader-jp2k=yes
EFL_DEPENDENCIES += openjpeg
else
EFL_CONF_OPTS += --disable-image-loader-jp2k
endif

ifeq ($(BR2_PACKAGE_EFL_WEBP),y)
EFL_CONF_OPTS += --enable-image-loader-webp=yes
EFL_DEPENDENCIES += webp
else
EFL_CONF_OPTS += --disable-image-loader-webp
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
# --enable-image-loader-gif=no: disable Gif dependency.
# --enable-image-loader-tiff=no: disable Tiff dependency.
# --with-crypto=none: remove dependencies on openssl or gnutls.
# --with-x11=none: remove dependency on X.org.
#   Yes I really know what I am doing.
HOST_EFL_CONF_OPTS += \
	--disable-audio \
	--disable-fontconfig \
	--disable-fribidi \
	--disable-gstreamer1 \
	--disable-libeeze \
	--disable-libmount \
	--disable-lua-old \
	--disable-multisense \
	--disable-physics \
	--enable-image-loader-gif=no \
	--enable-image-loader-jpeg=yes \
	--enable-image-loader-png=yes \
	--enable-image-loader-tiff=no \
	--with-crypto=none \
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

$(eval $(host-autotools-package))
