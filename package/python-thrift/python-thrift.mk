################################################################################
#
# python-thrift
#
################################################################################

PYTHON_THRIFT_VERSION = 0.11.0
PYTHON_THRIFT_SOURCE = thrift-$(PYTHON_THRIFT_VERSION).tar.gz
PYTHON_THRIFT_SITE = https://files.pythonhosted.org/packages/c6/b4/510617906f8e0c5660e7d96fbc5585113f83ad547a3989b80297ac72a74c
PYTHON_THRIFT_LICENSE = Apache-2.0
PYTHON_THRIFT_LICENSE_FILES = setup.py
PYTHON_THRIFT_SETUP_TYPE = setuptools

$(eval $(python-package))
