################################################################################
#
# libedje
#
################################################################################

LIBEDJE_VERSION = $(EFL_VERSION)
LIBEDJE_SOURCE = edje-$(LIBEDJE_VERSION).tar.bz2
LIBEDJE_SITE = http://download.enlightenment.org/releases
LIBEDJE_LICENSE = GPLv2+ (epp binary), BSD-2c (everything else)
LIBEDJE_LICENSE_FILES = COPYING

LIBEDJE_INSTALL_STAGING = YES

LIBEDJE_DEPENDENCIES = \
	host-pkgconf lua libeina libeet libecore libevas \
	libembryo

ifeq ($(BR2_PACKAGE_LIBEDJE_CC),y)
LIBEDJE_CONF_OPTS += --enable-edje-cc
else
LIBEDJE_CONF_OPTS += --disable-edje-cc
endif

HOST_LIBEDJE_CONF_OPTS = --enable-edje-cc

$(eval $(autotools-package))
$(eval $(host-autotools-package))
