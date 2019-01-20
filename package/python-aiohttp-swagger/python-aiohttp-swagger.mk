################################################################################
#
# python-apispec
#
################################################################################

PYTHON_AIOHTTP_SWAGGER_VERSION = 1.0.5
PYTHON_AIOHTTP_SWAGGER_SOURCE = aiohttp-swagger-$(PYTHON_AIOHTTP_SWAGGER_VERSION).tar.gz
PYTHON_AIOHTTP_SWAGGER_SITE = https://files.pythonhosted.org/packages/96/a9/4c74fbd561b3beea9d8926f91290b026e746d20279b876f98fb9ac0bbe02
PYTHON_AIOHTTP_SWAGGER_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_SWAGGER_LICENSE = Apache-2.0
PYTHON_AIOHTTP_SWAGGER_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
