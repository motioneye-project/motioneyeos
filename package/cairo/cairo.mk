################################################################################
#
# cairo
#
################################################################################

CAIRO_VERSION = 1.14.8
CAIRO_SOURCE = cairo-$(CAIRO_VERSION).tar.xz
CAIRO_LICENSE = LGPL-2.1 or MPL-1.1 (library)
CAIRO_LICENSE_FILES = COPYING COPYING-LGPL-2.1 COPYING-MPL-1.1
CAIRO_SITE = http://cairographics.org/releases
CAIRO_INSTALL_STAGING = YES
CAIRO_AUTORECONF = YES

# relocation truncated to fit: R_68K_GOT16O
ifeq ($(BR2_m68k_cf),y)
CAIRO_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -mxgot"
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),)
CAIRO_CONF_ENV += CPPFLAGS="$(TARGET_CPPFLAGS) -DCAIRO_NO_MUTEX=1"
endif

# cairo can use C++11 atomics when available, so we need to link with
# libatomic for the architectures who need libatomic.
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
CAIRO_CONF_ENV += LIBS="-latomic"
endif

CAIRO_CONF_OPTS = \
	--enable-trace=no \
	--enable-interpreter=no

CAIRO_DEPENDENCIES = host-pkgconf fontconfig pixman

# Just the bare minimum to make other host-* packages happy
HOST_CAIRO_CONF_OPTS = \
	--enable-trace=no \
	--enable-interpreter=no \
	--disable-directfb \
	--enable-ft \
	--disable-gobject \
	--disable-glesv2 \
	--disable-vg \
	--disable-xlib \
	--disable-xcb \
	--without-x \
	--disable-xlib-xrender \
	--disable-ps \
	--disable-pdf \
	--enable-png \
	--disable-script \
	--disable-svg \
	--disable-tee \
	--disable-xml
HOST_CAIRO_DEPENDENCIES = \
	host-freetype \
	host-fontconfig \
	host-libpng \
	host-pixman \
	host-pkgconf

# DirectFB svg support rely on Cairo and Cairo DirectFB support depends on
# DirectFB. Break circular dependency by disabling DirectFB support in Cairo
# (which is experimental)
ifeq ($(BR2_PACKAGE_DIRECTFB)x$(BR2_PACKAGE_DIRECTFB_SVG),yx)
CAIRO_CONF_OPTS += --enable-directfb
CAIRO_DEPENDENCIES += directfb
else
CAIRO_CONF_OPTS += --disable-directfb
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
CAIRO_CONF_OPTS += --enable-ft
CAIRO_DEPENDENCIES += freetype
else
CAIRO_CONF_OPTS += --disable-ft
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
CAIRO_CONF_OPTS += --enable-gobject
CAIRO_DEPENDENCIES += libglib2
else
CAIRO_CONF_OPTS += --disable-gobject
endif

# Can use GL or GLESv2 but not both
ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
CAIRO_CONF_OPTS += --enable-gl --disable-glesv2
CAIRO_DEPENDENCIES += libgl
else
ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
CAIRO_CONF_OPTS += --disable-gl --enable-glesv2
CAIRO_DEPENDENCIES += libgles
else
CAIRO_CONF_OPTS += --disable-gl --disable-glesv2
endif
endif

ifeq ($(BR2_PACKAGE_HAS_LIBOPENVG),y)
CAIRO_CONF_OPTS += --enable-vg
CAIRO_DEPENDENCIES += libopenvg
else
CAIRO_CONF_OPTS += --disable-vg
endif

ifeq ($(BR2_PACKAGE_LZO),y)
CAIRO_DEPENDENCIES += lzo
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
CAIRO_CONF_OPTS += --enable-xlib --enable-xcb --with-x
CAIRO_DEPENDENCIES += xlib_libX11 xlib_libXext
else
CAIRO_CONF_OPTS += --disable-xlib --disable-xcb --without-x
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRENDER),y)
CAIRO_CONF_OPTS += --enable-xlib-xrender
CAIRO_DEPENDENCIES += xlib_libXrender
else
CAIRO_CONF_OPTS += --disable-xlib-xrender
endif

ifeq ($(BR2_PACKAGE_CAIRO_PS),y)
CAIRO_CONF_OPTS += --enable-ps
CAIRO_DEPENDENCIES += zlib
else
CAIRO_CONF_OPTS += --disable-ps
endif

ifeq ($(BR2_PACKAGE_CAIRO_PDF),y)
CAIRO_CONF_OPTS += --enable-pdf
CAIRO_DEPENDENCIES += zlib
else
CAIRO_CONF_OPTS += --disable-pdf
endif

ifeq ($(BR2_PACKAGE_CAIRO_PNG),y)
CAIRO_CONF_OPTS += --enable-png
CAIRO_DEPENDENCIES += libpng
else
CAIRO_CONF_OPTS += --disable-png
endif

ifeq ($(BR2_PACKAGE_CAIRO_SCRIPT),y)
CAIRO_CONF_OPTS += --enable-script
else
CAIRO_CONF_OPTS += --disable-script
endif

ifeq ($(BR2_PACKAGE_CAIRO_SVG),y)
CAIRO_CONF_OPTS += --enable-svg
else
CAIRO_CONF_OPTS += --disable-svg
endif

ifeq ($(BR2_PACKAGE_CAIRO_TEE),y)
CAIRO_CONF_OPTS += --enable-tee
else
CAIRO_CONF_OPTS += --disable-tee
endif

ifeq ($(BR2_PACKAGE_CAIRO_XML),y)
CAIRO_CONF_OPTS += --enable-xml
else
CAIRO_CONF_OPTS += --disable-xml
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
