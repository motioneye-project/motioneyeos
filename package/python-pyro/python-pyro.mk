################################################################################
#
# python-pyro
#
################################################################################

PYTHON_PYRO_VERSION = 3.14
PYTHON_PYRO_SOURCE  = Pyro-$(PYTHON_PYRO_VERSION).tar.gz
PYTHON_PYRO_SITE    = https://pypi.python.org/packages/source/P/Pyro/
PYTHON_PYRO_LICENSE = MIT
PYTHON_PYRO_LICENSE_FILES = LICENSE
PYTHON_PYRO_DEPENDENCIES = python

define PYTHON_PYRO_INSTALL_TARGET_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
