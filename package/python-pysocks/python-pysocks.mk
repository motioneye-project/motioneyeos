################################################################################
#
# python-pysocks
#
################################################################################

PYTHON_PYSOCKS_VERSION = 1.6.7
PYTHON_PYSOCKS_SOURCE = PySocks-$(PYTHON_PYSOCKS_VERSION).tar.gz
PYTHON_PYSOCKS_SITE = https://pypi.python.org/packages/7d/38/edca891ce16827a1de45cc347e4b6c22311eba25838b9825a5e6c48cf560
PYTHON_PYSOCKS_LICENSE = BSD-3-Clause
PYTHON_PYSOCKS_LICENSE_FILES = LICENSE
PYTHON_PYSOCKS_SETUP_TYPE = setuptools

$(eval $(python-package))
