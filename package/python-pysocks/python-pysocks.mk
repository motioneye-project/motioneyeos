################################################################################
#
# python-pysocks
#
################################################################################

PYTHON_PYSOCKS_VERSION = 1.6.6
PYTHON_PYSOCKS_SOURCE = PySocks-$(PYTHON_PYSOCKS_VERSION).tar.gz
PYTHON_PYSOCKS_SITE = https://pypi.python.org/packages/fd/70/ba9982cedc9b3ed3c06934f1f46a609e0f23c7bfdf567c52a09f1296b8cb
PYTHON_PYSOCKS_LICENSE = BSD-3-Clause
PYTHON_PYSOCKS_LICENSE_FILES = socks.py
PYTHON_PYSOCKS_SETUP_TYPE = distutils

$(eval $(python-package))
