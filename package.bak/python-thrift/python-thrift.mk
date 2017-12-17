################################################################################
#
# python-thrift
#
################################################################################

PYTHON_THRIFT_VERSION = 0.9.3
PYTHON_THRIFT_SOURCE = thrift-$(PYTHON_THRIFT_VERSION).tar.gz
PYTHON_THRIFT_SITE = https://pypi.python.org/packages/ae/58/35e3f0cd290039ff862c2c9d8ae8a76896665d70343d833bdc2f748b8e55
PYTHON_THRIFT_LICENSE = Apache-2.0
PYTHON_THRIFT_LICENSE_FILES = setup.py
PYTHON_THRIFT_SETUP_TYPE = setuptools

$(eval $(python-package))
