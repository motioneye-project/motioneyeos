################################################################################
#
# python-pyasn
#
################################################################################

PYTHON_PYASN_VERSION = 0.1.7
PYTHON_PYASN_SOURCE = pyasn1-$(PYTHON_PYASN_VERSION).tar.gz
PYTHON_PYASN_SITE = https://pypi.python.org/packages/source/p/pyasn1
PYTHON_PYASN_LICENSE = BSD-2c
PYTHON_PYASN_LICENSE_FILES = LICENSE
PYTHON_PYASN_SETUP_TYPE = distutils

$(eval $(python-package))
