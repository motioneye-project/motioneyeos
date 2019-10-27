################################################################################
#
# dbus-python
#
################################################################################

DBUS_PYTHON_VERSION = 1.2.12
DBUS_PYTHON_SITE = http://dbus.freedesktop.org/releases/dbus-python
DBUS_PYTHON_INSTALL_STAGING = YES
DBUS_PYTHON_LICENSE = MIT (dbus-python), AFL-2.1 or GPL-2.0+ (dbus-gmain)
DBUS_PYTHON_LICENSE_FILES = COPYING dbus-gmain/COPYING
DBUS_PYTHON_DEPENDENCIES = dbus libglib2
HOST_DBUS_PYTHON_DEPENDENCIES = host-dbus host-libglib2

ifeq ($(BR2_PACKAGE_PYTHON),y)
DBUS_PYTHON_DEPENDENCIES += python host-python

DBUS_PYTHON_CONF_ENV += \
	PYTHON=$(HOST_DIR)/bin/python2 \
	PYTHON_INCLUDES="`$(STAGING_DIR)/usr/bin/python2-config --includes`" \
	PYTHON_LIBS="`$(STAGING_DIR)/usr/bin/python2-config --ldflags`"

HOST_DBUS_PYTHON_DEPENDENCIES += host-python

HOST_DBUS_PYTHON_CONF_ENV += \
	PYTHON=$(HOST_DIR)/bin/python2 \
	PYTHON_INCLUDES="`$(HOST_DIR)/usr/bin/python2-config --includes`" \
	PYTHON_LIBS="`$(HOST_DIR)/usr/bin/python2-config --ldflags`"
else
DBUS_PYTHON_DEPENDENCIES += python3 host-python3

DBUS_PYTHON_CONF_ENV += \
	PYTHON=$(HOST_DIR)/bin/python3 \
	PYTHON_INCLUDES="`$(STAGING_DIR)/usr/bin/python3-config --includes`" \
	PYTHON_LIBS="`$(STAGING_DIR)/usr/bin/python3-config --ldflags`" \
	PYTHON_EXTRA_LIBS="`$(STAGING_DIR)/usr/bin/python3-config --libs --embed`"

HOST_DBUS_PYTHON_DEPENDENCIES += host-python3

HOST_DBUS_PYTHON_CONF_ENV += \
	PYTHON=$(HOST_DIR)/bin/python3 \
	PYTHON_INCLUDES="`$(HOST_DIR)/usr/bin/python3-config --includes`" \
	PYTHON_LIBS="`$(HOST_DIR)/usr/bin/python3-config --ldflags`" \
	PYTHON_EXTRA_LIBS="`$(HOST_DIR)/usr/bin/python3-config --libs --embed`"
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
