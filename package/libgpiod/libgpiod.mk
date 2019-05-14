################################################################################
#
# libgpiod
#
################################################################################

LIBGPIOD_VERSION = 1.2.1
LIBGPIOD_SOURCE = libgpiod-$(LIBGPIOD_VERSION).tar.xz
LIBGPIOD_SITE = https://www.kernel.org/pub/software/libs/libgpiod
LIBGPIOD_LICENSE = LGPL-2.1+
LIBGPIOD_LICENSE_FILES = COPYING
LIBGPIOD_INSTALL_STAGING = YES
LIBGPIOD_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_LIBGPIOD_TOOLS),y)
LIBGPIOD_CONF_OPTS += --enable-tools
else
LIBGPIOD_CONF_OPTS += --disable-tools
endif

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
LIBGPIOD_CONF_OPTS += --enable-bindings-cxx
else
LIBGPIOD_CONF_OPTS += --disable-bindings-cxx
endif

ifeq ($(BR2_PACKAGE_PYTHON3),y)
LIBGPIOD_CONF_OPTS += --enable-bindings-python
LIBGPIOD_DEPENDENCIES += python3
LIBGPIOD_CONF_ENV += \
	PYTHON=$(HOST_DIR)/bin/python3 \
	PYTHON_CPPFLAGS="`$(STAGING_DIR)/usr/bin/python3-config --includes`" \
	PYTHON_LIBS="`$(STAGING_DIR)/usr/bin/python3-config --ldflags`"
else
LIBGPIOD_CONF_OPTS += --disable-bindings-python
endif

$(eval $(autotools-package))
