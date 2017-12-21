################################################################################
#
# python-dialog3
#
################################################################################

PYTHON_DIALOG3_VERSION = 3.4.0
PYTHON_DIALOG3_SOURCE = pythondialog-$(PYTHON_DIALOG3_VERSION).tar.bz2
PYTHON_DIALOG3_SITE = https://pypi.python.org/packages/fa/f4/686742f01ebb5863d4c5e1acab620acfed0fe97280a26b4ed25917f4f333
PYTHON_DIALOG3_LICENSE = LGPL-2.1+
PYTHON_DIALOG3_LICENSE_FILES = COPYING
PYTHON_DIALOG3_SETUP_TYPE = distutils
PYTHON_DIALOG3_DEPENDENCIES = dialog

$(eval $(python-package))
