################################################################################
#
# python-validators
#
################################################################################

PYTHON_VALIDATORS_VERSION = 0.12.6
PYTHON_VALIDATORS_SOURCE = validators-$(PYTHON_VALIDATORS_VERSION).tar.gz
PYTHON_VALIDATORS_SITE = https://files.pythonhosted.org/packages/8f/cd/1571ece4bf93e02143449417d244daa89dfc46288110b096b81e84aa6ddd
PYTHON_VALIDATORS_SETUP_TYPE = setuptools
PYTHON_VALIDATORS_LICENSE = BSD
PYTHON_VALIDATORS_LICENSE_FILES = LICENSE

$(eval $(python-package))
