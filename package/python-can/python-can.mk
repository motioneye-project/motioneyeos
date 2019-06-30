################################################################################
#
# python-can
#
################################################################################

PYTHON_CAN_VERSION = 3.3.0
PYTHON_CAN_SITE = https://files.pythonhosted.org/packages/9c/1e/a10b6f038a4a4bdd89d13ecc5fba36b71ab716fbd9eae9feda1d975d9504
PYTHON_CAN_SETUP_TYPE = setuptools
PYTHON_CAN_LICENSE = LGPL-3.0
PYTHON_CAN_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
