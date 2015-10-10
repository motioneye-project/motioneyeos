################################################################################
#
# libethumb
#
################################################################################

LIBETHUMB_VERSION = 1.7.10
LIBETHUMB_SOURCE = ethumb-$(LIBETHUMB_VERSION).tar.bz2
LIBETHUMB_SITE = http://download.enlightenment.org/releases
LIBETHUMB_LICENSE = LGPLv2.1+
LIBETHUMB_LICENSE_FILES = COPYING

LIBETHUMB_INSTALL_STAGING = YES

LIBETHUMB_DEPENDENCIES = libeina libevas libecore libedje host-libedje

LIBETHUMB_CONF_OPTS = --with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc

ifeq ($(BR2_PACKAGE_LIBEXIF),y)
LIBETHUMB_DEPENDENCIES += libexif
endif

ifeq ($(BR2_PACKAGE_LIBEDBUS),y)
LIBETHUMB_DEPENDENCIES += libedbus
endif

$(eval $(autotools-package))
