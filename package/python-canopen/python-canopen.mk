################################################################################
#
# python-canopen
#
################################################################################

PYTHON_CANOPEN_VERSION = 1.0.0
PYTHON_CANOPEN_SOURCE = canopen-$(PYTHON_CANOPEN_VERSION).tar.gz
PYTHON_CANOPEN_SITE = https://files.pythonhosted.org/packages/1f/2b/55b6d82b3dcba184a01c6fe027df239953940e36a463cd24b71e67bd1f37
PYTHON_CANOPEN_SETUP_TYPE = setuptools
PYTHON_CANOPEN_LICENSE = MIT
PYTHON_CANOPEN_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
