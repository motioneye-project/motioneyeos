################################################################################
#
# python-pathpy
#
################################################################################

PYTHON_PATHPY_VERSION = 10.0
PYTHON_PATHPY_SOURCE = path.py-$(PYTHON_PATHPY_VERSION).tar.gz
PYTHON_PATHPY_SITE = https://pypi.python.org/packages/f3/4e/3bce93c0d9e20abc6ed3aa7866beb688e889828ca2666743df11d9a30050
PYTHON_PATHPY_SETUP_TYPE = setuptools
PYTHON_PATHPY_LICENSE = MIT
PYTHON_PATHPY_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
