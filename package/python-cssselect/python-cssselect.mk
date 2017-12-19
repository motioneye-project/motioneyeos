################################################################################
#
# python-cssselect
#
################################################################################

PYTHON_CSSSELECT_VERSION = 1.0.1
PYTHON_CSSSELECT_SOURCE = cssselect-$(PYTHON_CSSSELECT_VERSION).tar.gz
PYTHON_CSSSELECT_SITE = https://pypi.python.org/packages/77/ff/9c865275cd19290feba56344eba570e719efb7ca5b34d67ed12b22ebbb0d
PYTHON_CSSSELECT_SETUP_TYPE = setuptools
PYTHON_CSSSELECT_LICENSE = BSD-3-Clause
PYTHON_CSSSELECT_LICENSE_FILES = LICENSE

$(eval $(python-package))
