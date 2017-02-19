################################################################################
#
# python-meld3
#
################################################################################

PYTHON_MELD3_VERSION = 1.0.2
PYTHON_MELD3_SOURCE = meld3-$(PYTHON_MELD3_VERSION).tar.gz
PYTHON_MELD3_SITE = https://pypi.python.org/packages/45/a0/317c6422b26c12fe0161e936fc35f36552069ba8e6f7ecbd99bbffe32a5f
PYTHON_MELD3_LICENSE = ZPLv2.1
PYTHON_MELD3_LICENSE_FILES = COPYRIGHT.txt LICENSE.txt
PYTHON_MELD3_SETUP_TYPE = setuptools

$(eval $(python-package))
