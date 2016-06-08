################################################################################
#
# python-pytz
#
################################################################################

PYTHON_PYTZ_VERSION = 2016.4
PYTHON_PYTZ_SOURCE = pytz-$(PYTHON_PYTZ_VERSION).tar.bz2
PYTHON_PYTZ_SITE = https://pypi.python.org/packages/f4/7d/7c0c85e9c64a75dde11bc9d3e1adc4e09a42ce7cdb873baffa1598118709
PYTHON_PYTZ_SETUP_TYPE = setuptools
PYTHON_PYTZ_LICENSE = MIT
PYTHON_PYTZ_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
