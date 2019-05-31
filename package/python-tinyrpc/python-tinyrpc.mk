################################################################################
#
# python-tinyrpc
#
################################################################################

PYTHON_TINYRPC_VERSION = 1.0.1
PYTHON_TINYRPC_SOURCE = tinyrpc-$(PYTHON_TINYRPC_VERSION).tar.gz
PYTHON_TINYRPC_SITE = https://files.pythonhosted.org/packages/1f/f9/d2f9aa8238fc4f3f92e3912b3768c67e3b74257fdf47da2db391354be285
PYTHON_TINYRPC_SETUP_TYPE = setuptools
PYTHON_TINYRPC_LICENSE = MIT
PYTHON_TINYRPC_LICENSE_FILES = LICENSE

$(eval $(python-package))
