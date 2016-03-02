################################################################################
#
# python-pygments
#
################################################################################

PYTHON_PYGMENTS_VERSION = 2.1
PYTHON_PYGMENTS_SOURCE = Pygments-$(PYTHON_PYGMENTS_VERSION).tar.gz
PYTHON_PYGMENTS_SITE = http://pypi.python.org/packages/source/P/Pygments
PYTHON_PYGMENTS_LICENSE = BSD-2c
PYTHON_PYGMENTS_LICENSE_FILES = LICENSE
PYTHON_PYGMENTS_SETUP_TYPE = setuptools

$(eval $(python-package))
