#############################################################
#
# libevas
#
#############################################################

LIBEVAS_VERSION = 1.1.0
LIBEVAS_SOURCE = evas-$(LIBEVAS_VERSION).tar.bz2
LIBEVAS_SITE = http://download.enlightenment.org/releases/
LIBEVAS_INSTALL_STAGING = YES

LIBEVAS_DEPENDENCIES = host-pkg-config zlib libeina freetype

HOST_LIBEVAS_DEPENDENCIES = host-pkg-config host-zlib host-libeina \
				host-freetype host-libpng
HOST_LIBEVAS_CONF_OPT += --enable-image-loader-png --disable-cpu-sse3

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
LIBEVAS_DEPENDENCIES += xproto_xproto
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_X11_GLX),y)
LIBEVAS_CONF_OPT += --enable-gl-xlib
LIBEVAS_DEPENDENCIES += xproto_glproto xlib_libX11
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
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_GLES_SGX),y)
LIBEVAS_CONF_OPT += --enable-gl-flavor-gles --enable-gles-variety-sgx
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_GLES_S3C6410),y)
LIBEVAS_CONF_OPT += --enable-gl-flavor-gles --enable-gles-variety-s3c6410
endif

# code options
ifeq ($(BR2_i386)$(BR2_x86_64),y)
# defaults
LIBEVAS_CONF_OPT += --disable-cpu-mmx --disable-cpu-sse --disable-cpu-sse3

# enable if cpu variant has mmx support
ifneq ($(BR2_x86_i386)$(BR2_x86_i486)$(BR2_x86_i586)$(BR2_x86_i686)$(BR2_x86_pentiumpro)$(BR2_x86_geode),y)
LIBEVAS_CONF_OPT += --enable-cpu-mmx

ifneq ($(BR2_x86_pentium_mmx)$(BR2_x86_pentium2)$(BR2_x86_k6)$(BR2_x86_k6_2)$(BR2_x86_athlon)$(BR2_x86_c3)$(BR2_x86_winchip_c6)$(BR2_x86_winchip2),y)
LIBEVAS_CONF_OPT += --enable-cpu-sse

ifneq ($(BR2_x86_pentium3)$(BR2_x86_pentium4)$(BR2_x86_prescott)$(BR2_x86_athlon_4)$(BR2_x86_opteron)$(BR2_x86_c32)$(BR2_x86_64_opteron),y)
LIBEVAS_CONF_OPT += --enable-cpu-sse3
endif # sse3
endif # sse
endif # mmx
endif # x86

ifeq ($(BR2_powerpc_7400)$(BR2_powerpc_7450)$(BR2_powerpc_970),y)
LIBEVAS_CONF_OPT += --enable-cpu-altivec
else
LIBEVAS_CONF_OPT += --disable-cpu-altivec
endif

ifeq ($(BR2_cortex_a8)$(BR2_cortex_a9),y)
# NEON is optional for A9
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

ifeq ($(BR2_PACKAGE_LIBEVAS_SVG),y)
LIBEVAS_CONF_OPT += --enable-image-loader-svg
else
LIBEVAS_CONF_OPT += --disable-image-loader-svg
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

# documentation
ifneq ($(BR2_HAVE_DOCUMENTATION),y)
LIBEVAS_CONF_OPT += --disable-doc
endif

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
