################################################################################
#
# python-tornado
#
################################################################################

PYTHON_TORNADO_VERSION = 6.0.1
PYTHON_TORNADO_SOURCE = tornado-$(PYTHON_TORNADO_VERSION).tar.gz
PYTHON_TORNADO_SITE = https://pypi.python.org/packages/b1/7f/8109821ff9df1bf3519169e34646705c32ac13be6a4d51a79ed57f47686e
PYTHON_TORNADO_LICENSE = Apache-2.0
PYTHON_TORNADO_LICENSE_FILES = LICENSE
PYTHON_TORNADO_SETUP_TYPE = setuptools

$(eval $(python-package))
