################################################################################
#
# python-validators
#
################################################################################

PYTHON_VALIDATORS_VERSION = 0.14.0
PYTHON_VALIDATORS_SOURCE = validators-$(PYTHON_VALIDATORS_VERSION).tar.gz
PYTHON_VALIDATORS_SITE = https://files.pythonhosted.org/packages/b2/b7/5fc43b7dba2a35362b2f5ce39dbee835c48898e2458910c3af810240fbaa
PYTHON_VALIDATORS_SETUP_TYPE = setuptools
PYTHON_VALIDATORS_LICENSE = BSD
PYTHON_VALIDATORS_LICENSE_FILES = LICENSE

$(eval $(python-package))
