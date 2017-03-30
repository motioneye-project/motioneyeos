################################################################################
#
# python-pylru
#
################################################################################

PYTHON_PYLRU_VERSION = 1.0.9
PYTHON_PYLRU_SOURCE = pylru-$(PYTHON_PYLRU_VERSION).tar.gz
PYTHON_PYLRU_SITE = https://pypi.python.org/packages/c0/7d/0de1055632f3871dfeaabe5a3f0510317cd98b93e7b792b44e4c7de2b17b
PYTHON_PYLRU_SETUP_TYPE = distutils
PYTHON_PYLRU_LICENSE = GPL-2.0
PYTHON_PYLRU_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
