################################################################################
#
# python-tornado
#
################################################################################

PYTHON_TORNADO_VERSION = 6.0.3
PYTHON_TORNADO_SOURCE = tornado-$(PYTHON_TORNADO_VERSION).tar.gz
PYTHON_TORNADO_SITE = https://files.pythonhosted.org/packages/30/78/2d2823598496127b21423baffaa186b668f73cd91887fcef78b6eade136b
PYTHON_TORNADO_LICENSE = Apache-2.0
PYTHON_TORNADO_LICENSE_FILES = LICENSE
PYTHON_TORNADO_SETUP_TYPE = setuptools

$(eval $(python-package))
