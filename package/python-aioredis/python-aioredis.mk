################################################################################
#
# python-aioredis
#
################################################################################

PYTHON_AIOREDIS_VERSION = 1.3.0
PYTHON_AIOREDIS_SOURCE = aioredis-$(PYTHON_AIOREDIS_VERSION).tar.gz
PYTHON_AIOREDIS_SITE = https://files.pythonhosted.org/packages/48/28/0bf4d0d218f521b95b0497b72135a4ff5ef55e62c72bb73babb0345a4627
PYTHON_AIOREDIS_SETUP_TYPE = setuptools
PYTHON_AIOREDIS_LICENSE = MIT
PYTHON_AIOREDIS_LICENSE_FILES = LICENSE

$(eval $(python-package))
