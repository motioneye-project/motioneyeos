################################################################################
#
# python-can
#
################################################################################

PYTHON_CAN_VERSION = 2.2.1
PYTHON_CAN_SITE = https://files.pythonhosted.org/packages/e6/49/7a25ca6f38421009621b9958a725a0bd57dc0caa656ee508324f26ea5363
PYTHON_CAN_LICENSE = LGPL-3.0
PYTHON_CAN_LICENSE_FILES = LICENSE.txt
PYTHON_CAN_SETUP_TYPE = setuptools

$(eval $(python-package))
