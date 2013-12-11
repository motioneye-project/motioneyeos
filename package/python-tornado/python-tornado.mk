################################################################################
#
# python-tornado
#
################################################################################

PYTHON_TORNADO_VERSION = 3.1.1
PYTHON_TORNADO_SOURCE = tornado-$(PYTHON_TORNADO_VERSION).tar.gz
PYTHON_TORNADO_SITE = https://pypi.python.org/packages/source/t/tornado
PYTHON_TORNADO_LICENSE = Apache-v2
PYTHON_TORNADO_SETUP_TYPE = setuptools

$(eval $(python-package))
