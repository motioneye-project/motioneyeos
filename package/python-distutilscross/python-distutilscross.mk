################################################################################
#
# python-distutilscross
#
################################################################################

PYTHON_DISTUTILSCROSS_VERSION = 0.1
PYTHON_DISTUTILSCROSS_SOURCE  = distutilscross-$(PYTHON_DISTUTILSCROSS_VERSION).tar.gz
PYTHON_DISTUTILSCROSS_SITE    = http://pypi.python.org/packages/source/d/distutilscross

HOST_PYTHON_DISTUTILSCROSS_DEPENDENCIES = host-python host-python-setuptools

define HOST_PYTHON_DISTUTILSCROSS_BUILD_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build)
endef

define HOST_PYTHON_DISTUTILSCROSS_INSTALL_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=$(HOST_DIR)/usr)
endef

$(eval $(host-generic-package))
