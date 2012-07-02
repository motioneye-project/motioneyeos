#############################################################
#
# python-serial
#
#############################################################

PYTHON_SERIAL_VERSION = 2.6
PYTHON_SERIAL_SOURCE  = pyserial-$(PYTHON_SERIAL_VERSION).tar.gz
PYTHON_SERIAL_SITE    = http://pypi.python.org/packages/source/p/pyserial/

PYTHON_SERIAL_DEPENDENCIES = python

define PYTHON_SERIAL_BUILD_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build)
endef

define PYTHON_SERIAL_INSTALL_TARGET_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
