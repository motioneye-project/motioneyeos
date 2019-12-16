################################################################################
#
# python-validators
#
################################################################################

PYTHON_VALIDATORS_VERSION = 0.14.1
PYTHON_VALIDATORS_SOURCE = validators-$(PYTHON_VALIDATORS_VERSION).tar.gz
PYTHON_VALIDATORS_SITE = https://files.pythonhosted.org/packages/72/8a/f99287daae8cfef938e6eec785f6e259bf6bad93269d5398bb546d5b1563
PYTHON_VALIDATORS_SETUP_TYPE = setuptools
PYTHON_VALIDATORS_LICENSE = BSD
PYTHON_VALIDATORS_LICENSE_FILES = LICENSE

$(eval $(python-package))
