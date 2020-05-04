################################################################################
#
# piglit
#
################################################################################

PIGLIT_VERSION = 2affee53f3ad7a96f5b397a2b6d6408af8a374b0
PIGLIT_SITE = https://gitlab.freedesktop.org/mesa/piglit.git
PIGLIT_SITE_METHOD = git
PIGLIT_LICENSE = MIT (code), \
	LGPL-2.0+ (tests/glslparsertest/glsl2/gst-gl-*), \
	LGPL-2.1+ (some tests), \
	GPL-3.0 (tests/glslparsertest/glsl2/norsetto-*), \
	GPL-2.0+ (tests/glslparsertest/glsl2/xreal-*, some other shaders), \
	BSD-3-Clause (tests/glslparsertest/shaders/*)
PIGLIT_LICENSE_FILES = COPYING licences/GPL-2 licences/GPL-3 licences/LGPL-2

PIGLIT_DEPENDENCIES = host-pkgconf \
	host-python-mako \
	host-python-numpy \
	host-python-six \
	libpng \
	python-mako \
	python-numpy \
	python-six \
	waffle \
	zlib

PIGLIT_CONF_OPTS += \
	-DPIGLIT_USE_WAFFLE=ON \
	-DPIGLIT_BUILD_CL_TESTS=OFF \
	-DPIGLIT_BUILD_WGL_TESTS=OFF \
	-DPYTHON_EXECUTABLE=$(HOST_DIR)/bin/python3

ifeq ($(BR2_PACKAGE_XORG7),y)
# libxcb for xcb-dri2
PIGLIT_DEPENDENCIES += \
	xlib_libX11 \
	xlib_libXext \
	xorgproto \
	$(if $(BR2_PACKAGE_LIBXCB),libxcb)
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
PIGLIT_DEPENDENCIES += libgl libdrm
PIGLIT_CONF_OPTS += -DPIGLIT_BUILD_GL_TESTS=ON
else
PIGLIT_CONF_OPTS += -DPIGLIT_BUILD_GL_TESTS=OFF
endif

ifeq ($(BR2_PACKAGE_XORG7)$(BR2_PACKAGE_HAS_LIBGL),yy)
PIGLIT_CONF_OPTS += -DPIGLIT_BUILD_GLX_TESTS=ON
else
PIGLIT_CONF_OPTS += -DPIGLIT_BUILD_GLX_TESTS=OFF
endif

ifeq ($(BR2_PACKAGE_HAS_LIBEGL)$(BR2_PACKAGE_HAS_LIBGLES),yy)
PIGLIT_DEPENDENCIES += libegl
PIGLIT_CONF_OPTS += -DPIGLIT_BUILD_GLES1_TESTS=ON \
	-DPIGLIT_BUILD_GLES2_TESTS=ON \
	-DPIGLIT_BUILD_GLES3_TESTS=ON
else
PIGLIT_CONF_OPTS += -DPIGLIT_BUILD_GLES1_TESTS=OFF \
	-DPIGLIT_BUILD_GLES2_TESTS=OFF \
	-DPIGLIT_BUILD_GLES3_TESTS=OFF
endif

ifeq ($(BR2_PACKAGE_WAYLAND),y)
PIGLIT_DEPENDENCIES += wayland libxkbcommon
endif

$(eval $(cmake-package))
