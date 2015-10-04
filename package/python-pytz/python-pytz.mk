################################################################################
#
# python-pytz
#
################################################################################

PYTHON_PYTZ_VERSION = 2014.2
PYTHON_PYTZ_SOURCE = pytz-$(PYTHON_PYTZ_VERSION).tar.gz
PYTHON_PYTZ_SITE = http://pypi.python.org/packages/source/p/pytz/
PYTHON_PYTZ_SETUP_TYPE = setuptools

$(eval $(python-package))
