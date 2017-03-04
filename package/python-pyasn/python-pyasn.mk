################################################################################
#
# python-pyasn
#
################################################################################

PYTHON_PYASN_VERSION = 1.6.0b1
PYTHON_PYASN_SOURCE = pyasn-$(PYTHON_PYASN_VERSION).tar.gz
PYTHON_PYASN_SITE = https://pypi.python.org/packages/31/da/c8338545be0ee7a727c977113e75888e4f1f2b2e10f9284fdfa31dab29bc
PYTHON_PYASN_LICENSE = BSD-2c
PYTHON_PYASN_LICENSE_FILES = LICENSE.txt
PYTHON_PYASN_SETUP_TYPE = distutils

$(eval $(python-package))
