################################################################################
#
# python-pycparser
#
################################################################################

PYTHON_PYCPARSER_VERSION = 2.14
PYTHON_PYCPARSER_SOURCE = pycparser-$(PYTHON_PYCPARSER_VERSION).tar.gz
PYTHON_PYCPARSER_SITE = https://pypi.python.org/packages/source/p/pycparser
PYTHON_PYCPARSER_SETUP_TYPE = setuptools
PYTHON_PYCPARSER_LICENSE = BSD-3c
PYTHON_PYCPARSER_LICENSE_FILES = LICENSE

$(eval $(host-python-package))
