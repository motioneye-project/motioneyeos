################################################################################
#
# python-httplib2
#
################################################################################

PYTHON_HTTPLIB2_VERSION = 0.9.2
PYTHON_HTTPLIB2_SOURCE = httplib2-$(PYTHON_HTTPLIB2_VERSION).tar.gz
PYTHON_HTTPLIB2_SITE = http://pypi.python.org/packages/source/h/httplib2
PYTHON_HTTPLIB2_SETUP_TYPE = setuptools
PYTHON_HTTPLIB2_LICENSE = MIT
PYTHON_HTTPLIB2_LICENSE_FILES = PKG-INFO

$(eval $(python-package))
