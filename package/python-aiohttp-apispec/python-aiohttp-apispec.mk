################################################################################
#
# python-aiohttp-apispec
#
################################################################################

PYTHON_AIOHTTP_APISPEC_VERSION = 0.7.7
PYTHON_AIOHTTP_APISPEC_SOURCE = aiohttp-$(PYTHON_AIOHTTP_APISPEC_VERSION).tar.gz
PYTHON_AIOHTTP_APISPEC_SITE = https://files.pythonhosted.org/packages/2f/4f/3085c9efff1ecf9949664769ffa55cb3702829c17a6c25e82671e85af24b
PYTHON_AIOHTTP_APISPEC_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_APISPEC_LICENSE = Apache-2.0
PYTHON_AIOHTTP_APISPEC_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
