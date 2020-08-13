################################################################################
#
# python-validators
#
################################################################################

PYTHON_VALIDATORS_VERSION = 0.14.2
PYTHON_VALIDATORS_SOURCE = validators-$(PYTHON_VALIDATORS_VERSION).tar.gz
PYTHON_VALIDATORS_SITE = https://files.pythonhosted.org/packages/4d/56/9b48c918ef118ea12b90f227c4498ed4703b418bdd8fb49479dfcbeae4ef
PYTHON_VALIDATORS_SETUP_TYPE = setuptools
PYTHON_VALIDATORS_LICENSE = MIT
PYTHON_VALIDATORS_LICENSE_FILES = LICENSE

$(eval $(python-package))
