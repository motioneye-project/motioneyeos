################################################################################
#
# python-can
#
################################################################################

PYTHON_CAN_VERSION = 3.3.1
PYTHON_CAN_SITE = https://files.pythonhosted.org/packages/d1/7e/d92889e3fa6ed625b5d6f065bff1c1b5921519a5133553905affb0d6b97c
PYTHON_CAN_SETUP_TYPE = setuptools
PYTHON_CAN_LICENSE = LGPL-3.0
PYTHON_CAN_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
