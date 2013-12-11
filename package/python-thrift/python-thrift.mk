################################################################################
#
# python-thrift
#
################################################################################

PYTHON_THRIFT_VERSION = 0.9.1
PYTHON_THRIFT_SOURCE = thrift-$(PYTHON_THRIFT_VERSION).tar.gz
PYTHON_THRIFT_SITE = http://www.us.apache.org/dist/thrift/$(PYTHON_THRIFT_VERSION)
PYTHON_THRIFT_LICENSE = Apache-2.0
PYTHON_THRIFT_LICENSE_FILES = LICENSE
PYTHON_THRIFT_SETUP_TYPE = setuptools
PYTHON_THRIFT_SUBDIR = lib/py

$(eval $(python-package))
