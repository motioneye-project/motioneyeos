################################################################################
#
# libelementary
#
################################################################################

LIBELEMENTARY_VERSION = $(EFL_VERSION)
LIBELEMENTARY_SOURCE = elementary-$(LIBELEMENTARY_VERSION).tar.bz2
LIBELEMENTARY_SITE = http://download.enlightenment.org/releases
LIBELEMENTARY_LICENSE = LGPLv2.1
LIBELEMENTARY_LICENSE_FILES = COPYING

LIBELEMENTARY_INSTALL_STAGING = YES

LIBELEMENTARY_DEPENDENCIES = libeina libevas libecore libedje host-libedje \
				host-libeet

LIBELEMENTARY_CONF_OPTS = --with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
			 --with-eet-eet=$(HOST_DIR)/usr/bin/eet

# libethumb_client is only built when ethumbd is built.
# ethumbd is only built if edbus is built.
ifeq ($(BR2_PACKAGE_LIBETHUMB)$(BR2_PACKAGE_LIBEDBUS),yy)
LIBELEMENTARY_DEPENDENCIES += libethumb
LIBELEMENTARY_CONF_OPTS += --enable-ethumb
else
LIBELEMENTARY_CONF_OPTS += --disable-ethumb
endif

$(eval $(autotools-package))
