################################################################################
#
# python-id3
#
################################################################################

PYTHON_ID3_VERSION = 1.2
PYTHON_ID3_SOURCE = id3-py_$(PYTHON_ID3_VERSION).tar.gz
PYTHON_ID3_SITE = http://downloads.sourceforge.net/project/id3-py/id3-py/$(PYTHON_ID3_VERSION)

PYTHON_ID3_DEPENDENCIES = python

define PYTHON_ID3_BUILD_CMDS
    (cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build)
endef

define PYTHON_ID3_INSTALL_TARGET_CMDS
    (cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
