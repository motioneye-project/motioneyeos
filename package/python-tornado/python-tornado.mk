################################################################################
#
# python-tornado
#
################################################################################

PYTHON_TORNADO_VERSION = 4.4.2
PYTHON_TORNADO_SOURCE = tornado-$(PYTHON_TORNADO_VERSION).tar.gz
PYTHON_TORNADO_SITE = https://pypi.python.org/packages/1e/7c/ea047f7bbd1ff22a7f69fe55e7561040e3e54d6f31da6267ef9748321f98
PYTHON_TORNADO_LICENSE = Apache-2.0
PYTHON_TORNADO_SETUP_TYPE = setuptools

$(eval $(python-package))
