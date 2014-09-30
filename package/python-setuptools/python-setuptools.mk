################################################################################
#
# python-setuptools
#
################################################################################

PYTHON_SETUPTOOLS_VERSION = 5.8
PYTHON_SETUPTOOLS_SOURCE = setuptools-$(PYTHON_SETUPTOOLS_VERSION).tar.gz
PYTHON_SETUPTOOLS_SITE = http://pypi.python.org/packages/source/s/setuptools
PYTHON_SETUPTOOLS_LICENSE = Python Software Foundation or Zope Public License
PYTHON_SETUPTOOLS_LICENSE_FILES = PKG-INFO
PYTHON_SETUPTOOLS_SETUP_TYPE = setuptools

$(eval $(python-package))
$(eval $(host-python-package))
