################################################################################
#
# python-pathpy
#
################################################################################

PYTHON_PATHPY_VERSION = 10.3.1
PYTHON_PATHPY_SOURCE = path.py-$(PYTHON_PATHPY_VERSION).tar.gz
PYTHON_PATHPY_SITE = https://pypi.python.org/packages/00/79/b1e5a02d156be8eedc1e60e5ce700edfb1d43992ec23f47da05fe5abe3a7
PYTHON_PATHPY_SETUP_TYPE = setuptools
PYTHON_PATHPY_LICENSE = MIT
PYTHON_PATHPY_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
