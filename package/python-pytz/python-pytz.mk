################################################################################
#
# python-pytz
#
################################################################################

PYTHON_PYTZ_VERSION = 2018.9
PYTHON_PYTZ_SOURCE = pytz-$(PYTHON_PYTZ_VERSION).tar.gz
PYTHON_PYTZ_SITE = https://files.pythonhosted.org/packages/af/be/6c59e30e208a5f28da85751b93ec7b97e4612268bb054d0dff396e758a90
PYTHON_PYTZ_SETUP_TYPE = setuptools
PYTHON_PYTZ_LICENSE = MIT
PYTHON_PYTZ_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
