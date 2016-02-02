################################################################################
#
# python-mistune
#
################################################################################

PYTHON_MISTUNE_VERSION = 0.7.1
PYTHON_MISTUNE_SOURCE = mistune-$(PYTHON_MISTUNE_VERSION).tar.gz
PYTHON_MISTUNE_SITE = http://pypi.python.org/packages/source/m/mistune
PYTHON_MISTUNE_LICENSE = BSD-3c
PYTHON_MISTUNE_LICENSE_FILES = LICENSE
PYTHON_MISTUNE_SETUP_TYPE = setuptools

$(eval $(python-package))
