################################################################################
#
# libevas
#
################################################################################

LIBEVAS_VERSION = $(EFL_VERSION)
LIBEVAS_SOURCE = evas-$(LIBEVAS_VERSION).tar.bz2
LIBEVAS_SITE = http://download.enlightenment.org/releases/
LIBEVAS_LICENSE = BSD-2c
LIBEVAS_LICENSE_FILES = COPYING

LIBEVAS_INSTALL_STAGING = YES

LIBEVAS_DEPENDENCIES = host-pkgconf zlib libeina freetype

HOST_LIBEVAS_DEPENDENCIES = host-pkgconf host-zlib host-libeina \
				host-freetype host-libpng host-libjpeg
HOST_LIBEVAS_CONF_OPT += \
	--enable-image-loader-png \
	--enable-image-loader-jpeg \
	--disable-image-loader-gif \
	--disable-image-loader-tiff \
	--disable-image-loader-eet \
	--disable-font-loader-eet \
	--disable-cpu-sse3 \
	--disable-software-sdl \
	--disable-gl-sdl \
	--disable-software-xlib \
	--disable-gl-xlib \
	--enable-software-xcb \
	--disable-gl-xcb

# rendering options
ifeq ($(BR2_PACKAGE_LIBEVAS_SCALE_SAMPLE),y)
LIBEVAS_CONF_OPT += --enable-scale-sample
else
LIBEVAS_CONF_OPT += --disable-scale-sample
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_SCALE_SMOOTH),y)
LIBEVAS_CONF_OPT += --enable-scale-smooth
else
LIBEVAS_CONF_OPT += --disable-scale-smooth
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_SMALL_DITHERING),y)
LIBEVAS_CONF_OPT += --enable-small-dither-mask
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_LINE_DITHERING),y)
LIBEVAS_CONF_OPT += --enable-line-dither-mask
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_NO_DITHERING),y)
LIBEVAS_CONF_OPT += --enable-no-dither-mask
endif

# backends
ifeq ($(BR2_PACKAGE_LIBEVAS_BUFFER),y)
LIBEVAS_CONF_OPT += --enable-buffer
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_X11),y)
LIBEVAS_CONF_OPT += --enable-software-xlib
LIBEVAS_DEPENDENCIES += xlib_libX11 xlib_libXext
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_X11_GLX),y)
LIBEVAS_CONF_OPT += --enable-gl-xlib
LIBEVAS_DEPENDENCIES += xproto_glproto xlib_libX11 xlib_libXrender \
			xlib_libXext libeet
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_XCB),y)
LIBEVAS_CONF_OPT += --enable-software-xcb
LIBEVAS_DEPENDENCIES += libxcb xcb-proto xcb-util pixman
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_XCB_GLX),y)
LIBEVAS_CONF_OPT += --enable-gl-xcb
LIBEVAS_DEPENDENCIES += libxcb xcb-proto xcb-util xproto_glproto
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_FB),y)
LIBEVAS_CONF_OPT += --enable-fb
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_DIRECTFB),y)
LIBEVAS_CONF_OPT += --enable-directfb
LIBEVAS_DEPENDENCIES += directfb
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_SDL),y)
LIBEVAS_CONF_OPT += --enable-software-sdl
LIBEVAS_DEPENDENCIES += sdl
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_SDL_GL),y)
LIBEVAS_CONF_OPT += --enable-gl-sdl
LIBEVAS_DEPENDENCIES += sdl
# configure script forgets to check for eet / fill this out
LIBEVAS_CONF_ENV += \
	GL_EET_CFLAGS='-I$(STAGING_DIR)/usr/include/eet-1' \
	GL_EET_LIBS='-leet'
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_GL),y)
LIBEVAS_DEPENDENCIES += mesa3d libeet
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_GLES_SGX),y)
LIBEVAS_CONF_OPT += --enable-gl-flavor-gles --enable-gles-variety-sgx
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_GLES_S3C6410),y)
LIBEVAS_CONF_OPT += --enable-gl-flavor-gles --enable-gles-variety-s3c6410
endif

# code options
ifeq ($(BR2_X86_CPU_HAS_MMX),y)
LIBEVAS_CONF_OPT += --enable-cpu-mmx
else
LIBEVAS_CONF_OPT += --disable-cpu-mmx
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
LIBEVAS_CONF_OPT += --enable-cpu-sse
else
LIBEVAS_CONF_OPT += --disable-cpu-sse
endif

ifeq ($(BR2_X86_CPU_HAS_SSE3),y)
LIBEVAS_CONF_OPT += --enable-cpu-sse3
else
LIBEVAS_CONF_OPT += --disable-cpu-sse3
endif

ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC),y)
LIBEVAS_CONF_OPT += --enable-cpu-altivec
else
LIBEVAS_CONF_OPT += --disable-cpu-altivec
endif

ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
LIBEVAS_CONF_OPT += --enable-cpu-neon
else
LIBEVAS_CONF_OPT += --disable-cpu-neon
endif

# loaders
ifeq ($(BR2_PACKAGE_LIBEVAS_PNG),y)
LIBEVAS_CONF_OPT += --enable-image-loader-png
LIBEVAS_DEPENDENCIES += libpng
else
LIBEVAS_CONF_OPT += --disable-image-loader-png
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_JPEG),y)
LIBEVAS_CONF_OPT += --enable-image-loader-jpeg
LIBEVAS_DEPENDENCIES += jpeg
else
LIBEVAS_CONF_OPT += --disable-image-loader-jpeg
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_GIF),y)
LIBEVAS_CONF_OPT += --enable-image-loader-gif
LIBEVAS_DEPENDENCIES += libungif
else
LIBEVAS_CONF_OPT += --disable-image-loader-gif
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_PMAPS),y)
LIBEVAS_CONF_OPT += --enable-image-loader-pmaps
else
LIBEVAS_CONF_OPT += --disable-image-loader-pmaps
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_TIFF),y)
LIBEVAS_CONF_OPT += --enable-image-loader-tiff
LIBEVAS_DEPENDENCIES += tiff
else
LIBEVAS_CONF_OPT += --disable-image-loader-tiff
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_XPM),y)
LIBEVAS_CONF_OPT += --enable-image-loader-xpm
else
LIBEVAS_CONF_OPT += --disable-image-loader-xpm
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_EET),y)
LIBEVAS_CONF_OPT += --enable-image-loader-eet
LIBEVAS_DEPENDENCIES += libeet
else
LIBEVAS_CONF_OPT += --disable-image-loader-eet
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_EET_FONT),y)
LIBEVAS_CONF_OPT += --enable-font-loader-eet
LIBEVAS_DEPENDENCIES += libeet
else
LIBEVAS_CONF_OPT += --disable-font-loader-eet
endif

# libevas installs the source code of examples on the target, which
# are generally not useful.
define LIBEVAS_REMOVE_EXAMPLES
	rm -rf $(TARGET_DIR)/usr/share/evas/examples/
endef

LIBEVAS_POST_INSTALL_TARGET_HOOKS += LIBEVAS_REMOVE_EXAMPLES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
