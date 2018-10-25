################################################################################
#
# python-pytz
#
################################################################################

PYTHON_PYTZ_VERSION = 2018.6
PYTHON_PYTZ_SOURCE = pytz-$(PYTHON_PYTZ_VERSION).tar.gz
PYTHON_PYTZ_SITE = https://files.pythonhosted.org/packages/c7/df/68a3331691a604a8241335064cf20742338d66eb008da96d4c9f3e3d4c41
PYTHON_PYTZ_SETUP_TYPE = setuptools
PYTHON_PYTZ_LICENSE = MIT
PYTHON_PYTZ_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
