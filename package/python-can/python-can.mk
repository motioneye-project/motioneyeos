################################################################################
#
# python-can
#
################################################################################

PYTHON_CAN_VERSION = 2.1.0
PYTHON_CAN_SITE = https://files.pythonhosted.org/packages/04/87/0d5b0f2f4e5d7f64a44f74b7f0bc1668457e6aa7e90b04ad15c3b9a44411
PYTHON_CAN_LICENSE = LGPL-3.0
PYTHON_CAN_LICENSE_FILES = LICENSE.txt
PYTHON_CAN_SETUP_TYPE = setuptools

$(eval $(python-package))
