################################################################################
#
# python-pysocks
#
################################################################################

PYTHON_PYSOCKS_VERSION = 1.7.1
PYTHON_PYSOCKS_SOURCE = PySocks-$(PYTHON_PYSOCKS_VERSION).tar.gz
PYTHON_PYSOCKS_SITE = https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11
PYTHON_PYSOCKS_LICENSE = BSD-3-Clause
PYTHON_PYSOCKS_LICENSE_FILES = LICENSE
PYTHON_PYSOCKS_SETUP_TYPE = setuptools

$(eval $(python-package))
