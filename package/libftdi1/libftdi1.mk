################################################################################
#
# libftdi1
#
################################################################################

LIBFTDI1_VERSION = 1.4
LIBFTDI1_SOURCE = libftdi1-$(LIBFTDI1_VERSION).tar.bz2
LIBFTDI1_SITE = http://www.intra2net.com/en/developer/libftdi/download
LIBFTDI1_INSTALL_STAGING = YES
LIBFTDI1_DEPENDENCIES = libusb
LIBFTDI1_LICENSE = LGPL-2.0 (libftdi1), GPL-2.0 with exception (ftdipp1)
LIBFTDI1_LICENSE_FILES = LICENSE COPYING.GPL COPYING.LIB
LIBFTDI1_CONF_OPTS = -DDOCUMENTATION=OFF -DEXAMPLES=OFF

ifeq ($(BR2_PACKAGE_LIBFTDI1_LIBFTDIPP1),y)
LIBFTDI1_DEPENDENCIES += boost
LIBFTDI1_CONF_OPTS += -DFTDIPP=ON
else
LIBFTDI1_CONF_OPTS += -DFTDIPP=OFF
endif

ifeq ($(BR2_PACKAGE_LIBFTDI1_PYTHON_BINDINGS),y)
LIBFTDI1_DEPENDENCIES += $(if $(BR2_PACKAGE_PYTHON),python,python3) host-swig
LIBFTDI1_CONF_OPTS += -DPYTHON_BINDINGS=ON
else
LIBFTDI1_CONF_OPTS += -DPYTHON_BINDINGS=OFF
endif

ifeq ($(BR2_PACKAGE_LIBFTDI1_FDTI_EEPROM),y)
# ftdi_eeprom optionally depends on libintl
LIBFTDI1_DEPENDENCIES += libconfuse $(TARGET_NLS_DEPENDENCIES)
LIBFTDI1_CONF_OPTS += -DFTDI_EEPROM=ON
else
LIBFTDI1_CONF_OPTS += -DFTDI_EEPROM=OFF
endif

$(eval $(cmake-package))
