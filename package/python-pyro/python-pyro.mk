################################################################################
#
# python-pyro
#
################################################################################

PYTHON_PYRO_VERSION = 3.16
PYTHON_PYRO_SOURCE = Pyro-$(PYTHON_PYRO_VERSION).tar.gz
PYTHON_PYRO_SITE = https://pypi.python.org/packages/61/68/0978adae315261b87acd216517c2c7f00780396e4d1426c5412458c6a28f
PYTHON_PYRO_LICENSE = MIT
PYTHON_PYRO_LICENSE_FILES = LICENSE
PYTHON_PYRO_SETUP_TYPE = distutils

$(eval $(python-package))
