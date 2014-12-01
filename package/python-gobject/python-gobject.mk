################################################################################
#
# python-gobject
#
################################################################################

PYTHON_GOBJECT_VERSION_MAJOR = 2.28
PYTHON_GOBJECT_VERSION = $(PYTHON_GOBJECT_VERSION_MAJOR).6
PYTHON_GOBJECT_SOURCE = pygobject-$(PYTHON_GOBJECT_VERSION).tar.xz
PYTHON_GOBJECT_SITE = http://ftp.gnome.org/pub/gnome/sources/pygobject/$(PYTHON_GOBJECT_VERSION_MAJOR)
PYTHON_GOBJECT_LICENSE = LGPLv2.1+
PYTHON_GOBJECT_LICENSE_FILES = COPYING
PYTHON_GOBJECT_DEPENDENCIES = host-pkgconf libglib2
PYTHON_GOBJECT_CONF_OPTS = --disable-introspection
# for 0001-add-PYTHON_INCLUDES-override.patch
PYTHON_GOBJECT_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_PYTHON),y)
PYTHON_GOBJECT_DEPENDENCIES += python host-python

PYTHON_GOBJECT_CONF_ENV = \
	PYTHON=$(HOST_DIR)/usr/bin/python2 \
	PYTHON_INCLUDES="$(shell $(STAGING_DIR)/usr/bin/python2-config --includes)"
else
PYTHON_GOBJECT_DEPENDENCIES += python3 host-python3

PYTHON_GOBJECT_CONF_ENV = \
	PYTHON=$(HOST_DIR)/usr/bin/python3 \
	PYTHON_INCLUDES="$(shell $(STAGING_DIR)/usr/bin/python3-config --includes)"
endif

ifeq ($(BR2_PACKAGE_LIBFFI),y)
PYTHON_GOBJECT_CONF_OPTS += --with-ffi
PYTHON_GOBJECT_DEPENDENCIES += libffi
else
PYTHON_GOBJECT_CONF_OPTS += --without-ffi
endif

$(eval $(autotools-package))
