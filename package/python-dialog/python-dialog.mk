################################################################################
#
# python-dialog
#
################################################################################

PYTHON_DIALOG_VERSION = 3.0.1
PYTHON_DIALOG_SOURCE = python2-pythondialog-$(PYTHON_DIALOG_VERSION).tar.bz2
PYTHON_DIALOG_SITE = http://downloads.sourceforge.net/project/pythondialog/pythondialog/$(PYTHON_DIALOG_VERSION)
PYTHON_DIALOG_LICENSE = LGPL-2.1+
PYTHON_DIALOG_LICENSE_FILES = COPYING
PYTHON_DIALOG_SETUP_TYPE = distutils
PYTHON_DIALOG_DEPENDENCIES = dialog

$(eval $(python-package))
