################################################################################
#
# python-pyxb
#
################################################################################

PYTHON_PYXB_VERSION = 1.2.6
PYTHON_PYXB_SOURCE = PyXB-$(PYTHON_PYXB_VERSION).tar.gz
PYTHON_PYXB_SITE = https://pypi.python.org/packages/e3/09/4fdb190ea2b7cb43d6d3e745276ee69f4d6181be70fcbfda7df3c5f72f0e
PYTHON_PYXB_LICENSE = Apache-2.0
PYTHON_PYXB_LICENSE_FILES = LICENSE
PYTHON_PYXB_SETUP_TYPE = distutils

$(eval $(python-package))
