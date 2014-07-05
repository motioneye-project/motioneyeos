################################################################################
#
# libv4l
#
################################################################################

LIBV4L_VERSION = 1.0.1
LIBV4L_SOURCE = v4l-utils-$(LIBV4L_VERSION).tar.bz2
LIBV4L_SITE = http://linuxtv.org/downloads/v4l-utils/
LIBV4L_INSTALL_STAGING = YES
LIBV4L_DEPENDENCIES = host-pkgconf

# v4l-utils components have different licences, see v4l-utils.spec for details
LIBV4L_LICENSE = GPLv2+ (utilities), LGPLv2.1+ (libraries)
LIBV4L_LICENSE_FILES = COPYING COPYING.libv4l lib/libv4l1/libv4l1-kernelcode-license.txt

ifeq ($(BR2_PACKAGE_ARGP_STANDALONE),y)
LIBV4L_DEPENDENCIES += argp-standalone
LIBV4L_CONF_ENV += LIBS="-largp"
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
LIBV4L_DEPENDENCIES += jpeg
LIBV4L_CONF_OPT += --with-jpeg
else
LIBV4L_CONF_OPT += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_LIBV4L_UTILS),y)
LIBV4L_CONF_OPT += --enable-v4l-utils
else
LIBV4L_CONF_OPT += --disable-v4l-utils
endif

$(eval $(autotools-package))
