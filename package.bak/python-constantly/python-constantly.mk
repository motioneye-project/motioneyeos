################################################################################
#
# python-constantly
#
################################################################################

PYTHON_CONSTANTLY_VERSION = 15.1.0
PYTHON_CONSTANTLY_SOURCE = constantly-$(PYTHON_CONSTANTLY_VERSION).tar.gz
PYTHON_CONSTANTLY_SITE = https://pypi.python.org/packages/95/f1/207a0a478c4bb34b1b49d5915e2db574cadc415c9ac3a7ef17e29b2e8951
PYTHON_CONSTANTLY_SETUP_TYPE = setuptools
PYTHON_CONSTANTLY_LICENSE = MIT
PYTHON_CONSTANTLY_LICENSE_FILES = LICENSE

$(eval $(python-package))
