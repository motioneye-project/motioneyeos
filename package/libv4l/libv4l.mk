################################################################################
#
# libv4l
#
################################################################################

LIBV4L_VERSION = 1.6.2
LIBV4L_SOURCE = v4l-utils-$(LIBV4L_VERSION).tar.bz2
LIBV4L_SITE = http://linuxtv.org/downloads/v4l-utils
LIBV4L_INSTALL_STAGING = YES
LIBV4L_DEPENDENCIES = host-pkgconf
LIBV4L_CONF_OPTS = --disable-doxygen-doc

# v4l-utils components have different licences, see v4l-utils.spec for details
LIBV4L_LICENSE = GPLv2+ (utilities), LGPLv2.1+ (libraries)
LIBV4L_LICENSE_FILES = COPYING COPYING.libv4l lib/libv4l1/libv4l1-kernelcode-license.txt

ifeq ($(BR2_PACKAGE_ARGP_STANDALONE),y)
LIBV4L_DEPENDENCIES += argp-standalone
LIBV4L_LIBS += -largp
endif

LIBV4L_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_PACKAGE_JPEG),y)
LIBV4L_DEPENDENCIES += jpeg
LIBV4L_CONF_OPTS += --with-jpeg
else
LIBV4L_CONF_OPTS += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
LIBV4L_CONF_OPTS += --with-libudev
LIBV4L_DEPENDENCIES += udev
else
LIBV4L_CONF_OPTS += --without-libudev
endif

ifeq ($(BR2_PACKAGE_LIBV4L_UTILS),y)
LIBV4L_CONF_OPTS += --enable-v4l-utils
# clock_gettime is used, which is provided by librt for glibc < 2.17
LIBV4L_LIBS += -lrt
else
LIBV4L_CONF_OPTS += --disable-v4l-utils
endif

LIBV4L_CONF_ENV += LIBS="$(LIBV4L_LIBS)"

$(eval $(autotools-package))
