################################################################################
#
# libsigrok
#
################################################################################

LIBSIGROK_VERSION = 0.5.2
LIBSIGROK_SITE = http://sigrok.org/download/source/libsigrok
LIBSIGROK_LICENSE = GPL-3.0+
LIBSIGROK_LICENSE_FILES = COPYING
LIBSIGROK_INSTALL_STAGING = YES
LIBSIGROK_DEPENDENCIES = libglib2 libzip host-pkgconf
LIBSIGROK_CONF_OPTS = --disable-java --disable-python

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS),y)
LIBSIGROK_CONF_OPTS += --with-libbluez
LIBSIGROK_DEPENDENCIES += bluez5_utils
else
LIBSIGROK_CONF_OPTS += --without-libbluez
endif

ifeq ($(BR2_PACKAGE_HIDAPI),y)
LIBSIGROK_CONF_OPTS += --with-libhidapi
LIBSIGROK_DEPENDENCIES += hidapi
else
LIBSIGROK_CONF_OPTS += --without-libhidapi
endif

ifeq ($(BR2_PACKAGE_LIBSERIALPORT),y)
LIBSIGROK_CONF_OPTS += --with-libserialport
LIBSIGROK_DEPENDENCIES += libserialport
else
LIBSIGROK_CONF_OPTS += --without-libserialport
endif

ifeq ($(BR2_PACKAGE_LIBFTDI1),y)
LIBSIGROK_CONF_OPTS += --with-libftdi
LIBSIGROK_DEPENDENCIES += libftdi1
else
LIBSIGROK_CONF_OPTS += --without-libftdi
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
LIBSIGROK_CONF_OPTS += --with-libusb
LIBSIGROK_DEPENDENCIES += libusb
else
LIBSIGROK_CONF_OPTS += --without-libusb
endif

ifeq ($(BR2_PACKAGE_GLIBMM),y)
LIBSIGROK_DEPENDENCIES += glibmm
endif

ifeq ($(BR2_PACKAGE_LIBSIGROKCXX),y)
LIBSIGROK_CONF_OPTS += --enable-cxx
# host-doxygen is used by C++ bindings to parse libsigrok symbols
LIBSIGROK_DEPENDENCIES += \
	glibmm \
	host-doxygen \
	$(if $(BR2_PACKAGE_PYTHON3),host-python3,host-python)
else
LIBSIGROK_CONF_OPTS += --disable-cxx
endif

$(eval $(autotools-package))
