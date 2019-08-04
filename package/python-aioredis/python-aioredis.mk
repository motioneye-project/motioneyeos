################################################################################
#
# python-aioredis
#
################################################################################

PYTHON_AIOREDIS_VERSION = 1.2.0
PYTHON_AIOREDIS_SOURCE = aioredis-$(PYTHON_AIOREDIS_VERSION).tar.gz
PYTHON_AIOREDIS_SITE = https://files.pythonhosted.org/packages/2e/a3/cd122b68d8071d332972027d225f548e0206001da1aa0685ea08db803b06
PYTHON_AIOREDIS_SETUP_TYPE = setuptools
PYTHON_AIOREDIS_LICENSE = MIT
PYTHON_AIOREDIS_LICENSE_FILES = LICENSE

$(eval $(python-package))
