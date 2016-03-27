################################################################################
#
# python-ptyprocess
#
################################################################################

PYTHON_PTYPROCESS_VERSION = 0.5.1
PYTHON_PTYPROCESS_SITE = https://pypi.python.org/packages/source/p/ptyprocess
PYTHON_PTYPROCESS_SOURCE = ptyprocess-$(PYTHON_PTYPROCESS_VERSION).tar.gz
PYTHON_PTYPROCESS_LICENSE = ISC
PYTHON_PTYPROCESS_LICENSE_FILES = LICENSE
PYTHON_PTYPROCESS_SETUP_TYPE = distutils

$(eval $(python-package))
