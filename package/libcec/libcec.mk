################################################################################
#
# libcec
#
################################################################################

LIBCEC_VERSION = libcec-2.1.1
LIBCEC_SITE = http://github.com/Pulse-Eight/libcec/tarball/$(LIBCEC_VERSION)
LIBCEC_LICENSE = GPLv2+
LIBCEC_LICENSE_FILE = COPYING

# Autoreconf required due to being a dev tarball and not a release tarball.
LIBCEC_AUTORECONF = YES
LIBCEC_INSTALL_STAGING = YES
LIBCEC_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_LOCKDEV),y)
LIBCEC_DEPENDENCIES += lockdev
endif

ifeq ($(BR2_PACKAGE_UDEV),y)
LIBCEC_DEPENDENCIES += udev
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
LIBCEC_CONF_OPT = --enable-rpi \
   --with-rpi-include-path=$(STAGING_DIR)/usr/include
LIBCEC_DEPENDENCIES += rpi-userland
else
LIBCEC_CONF_OPT = --disable-rpi
endif

$(eval $(autotools-package))
