################################################################################
#
# python-wsaccel
#
################################################################################

PYTHON_WSACCEL_VERSION = 0.6.2
PYTHON_WSACCEL_SOURCE = wsaccel-$(PYTHON_WSACCEL_VERSION).tar.gz
PYTHON_WSACCEL_SITE = https://pypi.python.org/packages/source/w/wsaccel
PYTHON_WSACCEL_LICENSE = Apache-2.0
PYTHON_WSACCEL_SETUP_TYPE = setuptools

$(eval $(python-package))
