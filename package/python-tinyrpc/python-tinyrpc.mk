################################################################################
#
# python-tinyrpc
#
################################################################################

PYTHON_TINYRPC_VERSION = 1.0.3
PYTHON_TINYRPC_SOURCE = tinyrpc-$(PYTHON_TINYRPC_VERSION).tar.gz
PYTHON_TINYRPC_SITE = https://files.pythonhosted.org/packages/21/7a/ff1a74256e1bcc04fbaa414c13a2bb79a29ac9918b25f2238592b991e3bc
PYTHON_TINYRPC_SETUP_TYPE = setuptools
PYTHON_TINYRPC_LICENSE = MIT
PYTHON_TINYRPC_LICENSE_FILES = LICENSE

$(eval $(python-package))
