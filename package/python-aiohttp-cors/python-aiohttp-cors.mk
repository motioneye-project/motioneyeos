################################################################################
#
# python-aiohttp-cors
#
################################################################################

PYTHON_AIOHTTP_CORS_VERSION = 0.7.0
PYTHON_AIOHTTP_CORS_SOURCE = aiohttp-cors-$(PYTHON_AIOHTTP_CORS_VERSION).tar.gz
PYTHON_AIOHTTP_CORS_SITE = https://files.pythonhosted.org/packages/44/9e/6cdce7c3f346d8fd487adf68761728ad8cd5fbc296a7b07b92518350d31f
PYTHON_AIOHTTP_CORS_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_CORS_LICENSE = Apache-2.0
PYTHON_AIOHTTP_CORS_LICENSE_FILES = LICENSE

$(eval $(python-package))
