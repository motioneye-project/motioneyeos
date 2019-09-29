################################################################################
#
# python-jsonmodels
#
################################################################################

PYTHON_JSONMODELS_VERSION = 2.4
PYTHON_JSONMODELS_SOURCE = jsonmodels-$(PYTHON_JSONMODELS_VERSION).tar.gz
PYTHON_JSONMODELS_SITE = https://files.pythonhosted.org/packages/68/00/524668dc751f9ef91e73c795b2073bf2ddb79728a474d1bcab9c6dc426d8
PYTHON_JSONMODELS_SETUP_TYPE = setuptools
PYTHON_JSONMODELS_LICENSE = BSD-3-Clause
PYTHON_JSONMODELS_LICENSE_FILES = LICENSE

$(eval $(python-package))
