################################################################################
#
# libfreeglut
#
################################################################################

LIBFREEGLUT_VERSION = 3.0.0
LIBFREEGLUT_SOURCE = freeglut-$(LIBFREEGLUT_VERSION).tar.gz
LIBFREEGLUT_SITE = http://downloads.sourceforge.net/freeglut
LIBFREEGLUT_LICENSE = MIT
LIBFREEGLUT_LICENSE_FILES = COPYING
LIBFREEGLUT_INSTALL_STAGING = YES
LIBFREEGLUT_DEPENDENCIES = \
	libgl \
	libglu \
	xlib_libXi \
	xlib_libXrandr \
	xlib_libXxf86vm

LIBFREEGLUT_CONF_OPTS = -DFREEGLUT_BUILD_DEMOS=OFF

# package depends on X.org which depends on !BR2_STATIC_LIBS
ifeq ($(BR2_SHARED_LIBS),y)
LIBFREEGLUT_CONF_OPTS += \
	-DFREEGLUT_BUILD_SHARED_LIBS=ON \
	-DFREEGLUT_BUILD_STATIC_LIBS=OFF
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
LIBFREEGLUT_CONF_OPTS += \
	-DFREEGLUT_BUILD_SHARED_LIBS=ON \
	-DFREEGLUT_BUILD_STATIC_LIBS=ON
endif

$(eval $(cmake-package))
