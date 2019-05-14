################################################################################
#
# python-aiohttp-apispec
#
################################################################################

PYTHON_AIOHTTP_APISPEC_VERSION = 1.1.2
PYTHON_AIOHTTP_APISPEC_SOURCE = aiohttp-apispec-$(PYTHON_AIOHTTP_APISPEC_VERSION).tar.gz
PYTHON_AIOHTTP_APISPEC_SITE = https://files.pythonhosted.org/packages/8e/b1/592284bf8c1384c3bbb57f2d057e681c6cf0c426f21bd55201bf3d877866
PYTHON_AIOHTTP_APISPEC_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_APISPEC_LICENSE = Apache-2.0
PYTHON_AIOHTTP_APISPEC_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
