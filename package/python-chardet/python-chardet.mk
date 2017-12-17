################################################################################
#
# python-chardet
#
################################################################################

PYTHON_CHARDET_VERSION = 3.0.4
PYTHON_CHARDET_SOURCE = chardet-$(PYTHON_CHARDET_VERSION).tar.gz
PYTHON_CHARDET_SITE = https://pypi.python.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d
PYTHON_CHARDET_SETUP_TYPE = setuptools
PYTHON_CHARDET_LICENSE = LGPL-2.1+
PYTHON_CHARDET_LICENSE_FILES = LICENSE

$(eval $(python-package))
