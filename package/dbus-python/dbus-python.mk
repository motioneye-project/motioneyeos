################################################################################
#
# dbus-python
#
################################################################################

DBUS_PYTHON_VERSION = 1.2.4
DBUS_PYTHON_SITE = http://dbus.freedesktop.org/releases/dbus-python
DBUS_PYTHON_INSTALL_STAGING = YES
DBUS_PYTHON_LICENSE = MIT
DBUS_PYTHON_LICENSE_FILES = COPYING
DBUS_PYTHON_DEPENDENCIES = dbus-glib
DBUS_PYTHON_CONF_OPTS = --disable-html-docs --disable-api-docs

ifeq ($(BR2_PACKAGE_PYTHON),y)
DBUS_PYTHON_DEPENDENCIES += python host-python

DBUS_PYTHON_CONF_ENV += \
	PYTHON=$(HOST_DIR)/bin/python2 \
	PYTHON_INCLUDES="`$(STAGING_DIR)/usr/bin/python2-config --includes`" \
	PYTHON_LIBS="`$(STAGING_DIR)/usr/bin/python2-config --ldflags`"
else
DBUS_PYTHON_DEPENDENCIES += python3 host-python3

DBUS_PYTHON_CONF_ENV += \
	PYTHON=$(HOST_DIR)/bin/python3 \
	PYTHON_INCLUDES="`$(STAGING_DIR)/usr/bin/python3-config --includes`" \
	PYTHON_LIBS="`$(STAGING_DIR)/usr/bin/python3-config --ldflags`"
endif

$(eval $(autotools-package))
