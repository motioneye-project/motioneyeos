################################################################################
#
# python-can
#
################################################################################

PYTHON_CAN_VERSION = 3.0.0
PYTHON_CAN_SITE = https://files.pythonhosted.org/packages/29/47/59d07bb02d6b244fb631487ae5424a10658c316defeeb90c923b48043792
PYTHON_CAN_SETUP_TYPE = setuptools
PYTHON_CAN_LICENSE = LGPL-3.0
PYTHON_CAN_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
