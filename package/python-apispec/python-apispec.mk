################################################################################
#
# python-apispec
#
################################################################################

PYTHON_APISPEC_VERSION = 0.39.0
PYTHON_APISPEC_SOURCE = aiohttp-$(PYTHON_APISPEC_VERSION).tar.gz
PYTHON_APISPEC_SITE = https://files.pythonhosted.org/packages/e9/92/833b2715566b9fe4a34ea544f48f997b3468cbe4c2a2a70d8dd432830c24
PYTHON_APISPEC_SETUP_TYPE = setuptools
PYTHON_APISPEC_LICENSE = Apache-2.0
PYTHON_APISPEC_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
