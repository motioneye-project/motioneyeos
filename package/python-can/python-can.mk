################################################################################
#
# python-can
#
################################################################################

PYTHON_CAN_VERSION = 1.4.3
PYTHON_CAN_SITE = https://pypi.python.org/packages/source/p/python-can
PYTHON_CAN_LICENSE = LGPL-3.0
PYTHON_CAN_LICENSE_FILES = LICENSE.txt
PYTHON_CAN_SETUP_TYPE = setuptools

$(eval $(python-package))
