################################################################################
#
# python-bottle
#
################################################################################

PYTHON_BOTTLE_VERSION = 0.11.6
PYTHON_BOTTLE_SOURCE = bottle-$(PYTHON_BOTTLE_VERSION).tar.gz
PYTHON_BOTTLE_SITE = http://pypi.python.org/packages/source/b/bottle
PYTHON_BOTTLE_DEPENDENCIES = python
PYTHON_BOTTLE_LICENSE = MIT
# README.rst refers to the file "LICENSE" but it's not included

define PYTHON_BOTTLE_BUILD_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build --executable=/usr/bin/python)
endef

define PYTHON_BOTTLE_INSTALL_TARGET_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
