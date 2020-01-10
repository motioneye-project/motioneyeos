################################################################################
#
# python-aioredis
#
################################################################################

PYTHON_AIOREDIS_VERSION = 1.3.1
PYTHON_AIOREDIS_SOURCE = aioredis-$(PYTHON_AIOREDIS_VERSION).tar.gz
PYTHON_AIOREDIS_SITE = https://files.pythonhosted.org/packages/2c/2a/662e5e79dde5d00964b995d50e38ecdefeeeb09b37edafff193c7e850f46
PYTHON_AIOREDIS_SETUP_TYPE = setuptools
PYTHON_AIOREDIS_LICENSE = MIT
PYTHON_AIOREDIS_LICENSE_FILES = LICENSE

$(eval $(python-package))
