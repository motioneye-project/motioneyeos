################################################################################
#
# python-pyxb
#
################################################################################

PYTHON_PYXB_VERSION = 1.2.5
PYTHON_PYXB_SOURCE = PyXB-$(PYTHON_PYXB_VERSION).tar.gz
PYTHON_PYXB_SITE = https://pypi.python.org/packages/43/7a/9d40392e4380463f37bf5aa2851dfd8ba7c0e4d2a9dc2355177b8b785794
PYTHON_PYXB_LICENSE = Apache-2.0
PYTHON_PYXB_LICENSE_FILES = LICENSE
PYTHON_PYXB_SETUP_TYPE = distutils

$(eval $(python-package))
