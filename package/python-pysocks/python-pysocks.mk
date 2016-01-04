################################################################################
#
# python-pysocks
#
################################################################################

PYTHON_PYSOCKS_VERSION = 1.5.6
PYTHON_PYSOCKS_SOURCE = PySocks-$(PYTHON_PYSOCKS_VERSION).tar.gz
PYTHON_PYSOCKS_SITE = https://pypi.python.org/packages/source/P/PySocks
PYTHON_PYSOCKS_LICENSE = BSD-3c
PYTHON_PYSOCKS_LICENSE_FILES = socks.py
PYTHON_PYSOCKS_SETUP_TYPE = distutils

$(eval $(python-package))
