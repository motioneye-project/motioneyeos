################################################################################
#
# fcgiwrap
#
################################################################################

FCGIWRAP_VERSION = 99c942c90063c73734e56bacaa65f947772d9186
FCGIWRAP_SITE = $(call github,gnosek,fcgiwrap,$(FCGIWRAP_VERSION))
FCGIWRAP_DEPENDENCIES = host-pkgconf libfcgi
FCGIWRAP_LICENSE = MIT
FCGIWRAP_LICENSE_FILES = COPYING
FCGIWRAP_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
FCGIWRAP_DEPENDENCIES += systemd
FCGIWRAP_CONF_OPTS += --with-systemd
else
FCGIWRAP_CONF_OPTS += --without-systemd
endif

# libfcgi needs libm and fcgiwrap does not use libtool or pkgconf to
# detect libfcgi, so we need to add -lm explicitely when using static
# libs.
ifeq ($(BR2_STATIC_LIBS),y)
FCGIWRAP_CONF_OPTS += LIBS=-lm
endif

# fcgiwrap uses Autoconf, but not Automake, so we need to provide
# these to make.
FCGIWRAP_MAKE_ENV = $(TARGET_CONFIGURE_OPTS)

$(eval $(autotools-package))
