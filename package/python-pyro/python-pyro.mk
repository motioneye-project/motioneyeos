################################################################################
#
# python-pyro
#
################################################################################

PYTHON_PYRO_VERSION = 3.14
PYTHON_PYRO_SOURCE  = Pyro-$(PYTHON_PYRO_VERSION).tar.gz
PYTHON_PYRO_SITE    = https://pypi.python.org/packages/source/P/Pyro
PYTHON_PYRO_LICENSE = MIT
PYTHON_PYRO_LICENSE_FILES = LICENSE
PYTHON_PYRO_SETUP_TYPE = distutils

$(eval $(python-package))
