################################################################################
#
# python-six
#
################################################################################

PYTHON_SIX_VERSION = 1.10.0
PYTHON_SIX_SOURCE = six-$(PYTHON_SIX_VERSION).tar.gz
PYTHON_SIX_SITE = https://pypi.python.org/packages/source/s/six
PYTHON_SIX_SETUP_TYPE = setuptools
PYTHON_SIX_LICENSE = MIT
PYTHON_SIX_LICENSE_FILES = LICENSE

$(eval $(python-package))
