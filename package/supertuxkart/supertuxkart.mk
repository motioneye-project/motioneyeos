################################################################################
#
# supertuxkart
#
################################################################################

SUPERTUXKART_VERSION = 0.9.2
SUPERTUXKART_SOURCE = supertuxkart-$(SUPERTUXKART_VERSION)-src.tar.xz
SUPERTUXKART_SITE = http://downloads.sourceforge.net/project/supertuxkart/SuperTuxKart/$(SUPERTUXKART_VERSION)

# Supertuxkart itself is GPLv3+, but it bundles a few libraries with different
# licenses. Irrlicht, bullet and angelscript have zlib license, while glew is
# BSD-3c. Since they are linked statically, the result is GPLv3+.
SUPERTUXKART_LICENSE = GPLv3+
SUPERTUXKART_LICENSE_FILES = COPYING

SUPERTUXKART_DEPENDENCIES = \
	jpeg \
	libcurl \
	libgl \
	libglu \
	libogg \
	libpng \
	libvorbis \
	openal \
	xlib_libXrandr \
	zlib

# Since supertuxkart is not installing libstkirrlicht.so, and since it is
# the only user of the bundled libraries, turn off shared libraries entirely.
SUPERTUXKART_CONF_OPTS = -DBUILD_SHARED_LIBS=OFF

ifeq ($(BR2_PACKAGE_LIBFRIBIDI),y)
SUPERTUXKART_DEPENDENCIES += libfribidi
SUPERTUXKART_CONF_OPTS += -DUSE_FRIBIDI=ON
else
SUPERTUXKART_CONF_OPTS += -DUSE_FRIBIDI=OFF
endif

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS),y)
SUPERTUXKART_DEPENDENCIES += bluez5_utils
SUPERTUXKART_CONF_OPTS += -DUSE_WIIUSE=ON
else
# Wiimote support relies on bluez5.
SUPERTUXKART_CONF_OPTS += -DUSE_WIIUSE=OFF
endif

$(eval $(cmake-package))
