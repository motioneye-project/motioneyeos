################################################################################
#
# python-pysocks
#
################################################################################

PYTHON_PYSOCKS_VERSION = 1.5.7
PYTHON_PYSOCKS_SOURCE = PySocks-$(PYTHON_PYSOCKS_VERSION).tar.gz
PYTHON_PYSOCKS_SITE = https://pypi.python.org/packages/16/56/9b3513078f837fa8cb88ee01ec1cd805ed8104a37bc02ca8c2588ae8fe5a
PYTHON_PYSOCKS_LICENSE = BSD-3c
PYTHON_PYSOCKS_LICENSE_FILES = socks.py
PYTHON_PYSOCKS_SETUP_TYPE = distutils

$(eval $(python-package))
