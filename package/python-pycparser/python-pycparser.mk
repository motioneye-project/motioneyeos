################################################################################
#
# python-pycparser
#
################################################################################

PYTHON_PYCPARSER_VERSION = 2.19
PYTHON_PYCPARSER_SOURCE = pycparser-$(PYTHON_PYCPARSER_VERSION).tar.gz
PYTHON_PYCPARSER_SITE = https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a
PYTHON_PYCPARSER_SETUP_TYPE = setuptools
PYTHON_PYCPARSER_LICENSE = BSD-3-Clause
PYTHON_PYCPARSER_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
