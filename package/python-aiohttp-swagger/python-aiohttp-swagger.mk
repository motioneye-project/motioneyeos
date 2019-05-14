################################################################################
#
# python-aiohttp-swagger
#
################################################################################

PYTHON_AIOHTTP_SWAGGER_VERSION = 39687734726ac72067f4e77209440757925dd6f2
PYTHON_AIOHTTP_SWAGGER_SITE = $(call github,eLvErDe,aiohttp-swagger,$(PYTHON_AIOHTTP_SWAGGER_VERSION))
PYTHON_AIOHTTP_SWAGGER_SETUP_TYPE = setuptools
PYTHON_AIOHTTP_SWAGGER_LICENSE = Apache-2.0
PYTHON_AIOHTTP_SWAGGER_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
