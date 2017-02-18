################################################################################
#
# libmng
#
################################################################################

LIBMNG_VERSION = 2.0.3
LIBMNG_SITE = http://downloads.sourceforge.net/project/libmng/libmng-devel/$(LIBMNG_VERSION)
LIBMNG_SOURCE = libmng-$(LIBMNG_VERSION).tar.xz
LIBMNG_DEPENDENCIES = jpeg zlib
LIBMNG_CONF_OPTS = --without-lcms
LIBMNG_INSTALL_STAGING = YES
LIBMNG_LICENSE = libmng license
LIBMNG_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_LCMS2),y)
LIBMNG_DEPDENDENCIES += lcms2
else
LIBMNG_CONF_OPTS += --without-lcms2
endif

$(eval $(autotools-package))
