################################################################################
#
# python-pyicu
#
################################################################################

PYTHON_PYICU_VERSION = 1.9.7
PYTHON_PYICU_SOURCE = PyICU-$(PYTHON_PYICU_VERSION).tar.gz
PYTHON_PYICU_SITE = https://pypi.python.org/packages/6e/88/f42a1297909ca6d9113ba37b37067011ae29432fe592fdd98cf52ad23b77
PYTHON_PYICU_LICENSE = MIT
PYTHON_PYICU_LICENSE_FILES = LICENSE
PYTHON_PYICU_DEPENDENCIES = icu
PYTHON_PYICU_SETUP_TYPE = setuptools

$(eval $(python-package))
