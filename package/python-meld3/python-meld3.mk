################################################################################
#
# python-meld3
#
################################################################################

PYTHON_MELD3_VERSION = 0.6.8
PYTHON_MELD3_SOURCE = meld3-$(PYTHON_MELD3_VERSION).tar.gz
PYTHON_MELD3_SITE = http://pypi.python.org/packages/source/m/meld3/
PYTHON_MELD3_DEPENDENCIES = python
PYTHON_MELD3_LICENSE = ZPLv2.1
PYTHON_MELD3_LICENSE_FILES = COPYRIGHT.txt LICENSE.txt

define PYTHON_MELD3_BUILD_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build)
endef

define PYTHON_MELD3_INSTALL_TARGET_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
