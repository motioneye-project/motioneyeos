################################################################################
#
# python-meld3
#
################################################################################

PYTHON_MELD3_VERSION = 0.6.8
PYTHON_MELD3_SOURCE = meld3-$(PYTHON_MELD3_VERSION).tar.gz
PYTHON_MELD3_SITE = http://pypi.python.org/packages/source/m/meld3/
PYTHON_MELD3_LICENSE = ZPLv2.1
PYTHON_MELD3_LICENSE_FILES = COPYRIGHT.txt LICENSE.txt
PYTHON_MELD3_SETUP_TYPE = distutils

$(eval $(python-package))
