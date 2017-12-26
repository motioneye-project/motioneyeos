################################################################################
#
# libgta
#
################################################################################

LIBGTA_VERSION = 1.0.8
LIBGTA_SITE = http://download.savannah.nongnu.org/releases/gta
LIBGTA_SOURCE = libgta-$(LIBGTA_VERSION).tar.xz
LIBGTA_INSTALL_STAGING = YES
LIBGTA_DEPENDENCIES = host-pkgconf bzip2 xz zlib
LIBGTA_LICENSE = LGPL-2.1+
LIBGTA_LICENSE_FILES = COPYING

LIBGTA_CONF_OPTS += -DGTA_BUILD_DOCUMENTATION=OFF

ifeq ($(BR2_STATIC_LIBS),)
LIBGTA_CONF_OPTS += -DGTA_BUILD_SHARED_LIB=ON
else
LIBGTA_CONF_OPTS += -DGTA_BUILD_SHARED_LIB=OFF
endif

ifeq ($(BR2_SHARED_LIBS),)
LIBGTA_CONF_OPTS += -DGTA_BUILD_STATIC_LIB=ON
else
LIBGTA_CONF_OPTS += -DGTA_BUILD_STATIC_LIB=OFF
endif

$(eval $(cmake-package))
