################################################################################
#
# python-pydal
#
################################################################################

PYTHON_PYDAL_VERSION = 17.8
PYTHON_PYDAL_SOURCE = pyDAL-$(PYTHON_PYDAL_VERSION).tar.gz
PYTHON_PYDAL_SITE = https://pypi.python.org/packages/e3/bd/1d5ca8be486d845074161456637f7d73acc09dc6c8d69bf0e7ad55ce9027
PYTHON_PYDAL_LICENSE = BSD-3-Clause
PYTHON_PYDAL_LICENSE_FILES = LICENSE
PYTHON_PYDAL_SETUP_TYPE = setuptools

$(eval $(python-package))
$(eval $(host-python-package))
