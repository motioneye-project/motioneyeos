################################################################################
#
# libsigrok
#
################################################################################

LIBSIGROK_VERSION = 0.5.0
LIBSIGROK_SITE = http://sigrok.org/download/source/libsigrok
LIBSIGROK_LICENSE = GPL-3.0+
LIBSIGROK_LICENSE_FILES = COPYING
LIBSIGROK_INSTALL_STAGING = YES
LIBSIGROK_DEPENDENCIES = libglib2 libzip host-pkgconf
LIBSIGROK_CONF_OPTS = --disable-glibtest --disable-java --disable-python

ifeq ($(BR2_PACKAGE_LIBSERIALPORT),y)
LIBSIGROK_CONF_OPTS += --enable-libserialport
LIBSIGROK_DEPENDENCIES += libserialport
else
LIBSIGROK_CONF_OPTS += --disable-libserialport
endif

ifeq ($(BR2_PACKAGE_LIBFTDI),y)
LIBSIGROK_CONF_OPTS += --enable-libftdi
LIBSIGROK_DEPENDENCIES += libftdi
else
LIBSIGROK_CONF_OPTS += --disable-libftdi
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
LIBSIGROK_CONF_OPTS += --enable-libusb
LIBSIGROK_DEPENDENCIES += libusb
else
LIBSIGROK_CONF_OPTS += --disable-libusb
endif

ifeq ($(BR2_PACKAGE_GLIBMM),y)
LIBSIGROK_DEPENDENCIES += glibmm
endif

ifeq ($(BR2_PACKAGE_LIBSIGROKCXX),y)
LIBSIGROK_CONF_OPTS += --enable-cxx
LIBSIGROK_AUTORECONF_OPTS += -I $(HOST_DIR)/share/autoconf-archive
LIBSIGROK_DEPENDENCIES += \
	host-autoconf-archive \
	glibmm \
	host-doxygen \
	$(if $(BR2_PACKAGE_PYTHON3),host-python3,host-python)
else
LIBSIGROK_CONF_OPTS += --disable-cxx
endif

$(eval $(autotools-package))
