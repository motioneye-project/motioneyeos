################################################################################
#
# python-dialog
#
################################################################################

PYTHON_DIALOG_VERSION = 3.0.1
PYTHON_DIALOG_SOURCE  = python2-pythondialog-$(PYTHON_DIALOG_VERSION).tar.bz2
PYTHON_DIALOG_SITE    = http://downloads.sourceforge.net/project/pythondialog/pythondialog/$(PYTHON_DIALOG_VERSION)
PYTHON_DIALOG_LICENSE = LGPLv2.1+
PYTHON_DIALOG_LICENSE_FILES = COPYING

PYTHON_DIALOG_DEPENDENCIES = python dialog

define PYTHON_DIALOG_BUILD_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build)
endef

define PYTHON_DIALOG_INSTALL_TARGET_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
