################################################################################
#
# python-pyicu
#
################################################################################

PYTHON_PYICU_VERSION = 1.9.3
PYTHON_PYICU_SOURCE = PyICU-$(PYTHON_PYICU_VERSION).tar.gz
PYTHON_PYICU_SITE = https://pypi.python.org/packages/bf/1f/cea237f542e3bb592980008a734850e8cbbc25c19c72c98767c71c1bd9c2
PYTHON_PYICU_LICENSE = MIT
PYTHON_PYICU_LICENSE_FILES = LICENSE
PYTHON_PYICU_DEPENDENCIES = icu
PYTHON_PYICU_SETUP_TYPE = setuptools

$(eval $(python-package))
