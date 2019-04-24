################################################################################
#
# python-can
#
################################################################################

PYTHON_CAN_VERSION = 3.1.1
PYTHON_CAN_SITE = https://files.pythonhosted.org/packages/c1/b0/72d7ed7840692ace5b55dd1155409cd86fd83cee4ded75e3d1102c08750a
PYTHON_CAN_SETUP_TYPE = setuptools
PYTHON_CAN_LICENSE = LGPL-3.0
PYTHON_CAN_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
