################################################################################
#
# python-u-msgpack
#
################################################################################

PYTHON_U_MSGPACK_VERSION = 2.5.2
PYTHON_U_MSGPACK_SOURCE = u-msgpack-python-$(PYTHON_U_MSGPACK_VERSION).tar.gz
PYTHON_U_MSGPACK_SITE = https://files.pythonhosted.org/packages/75/c4/d9404382d0f7d9be27b5d13498d033a4faa83f325b3893e1c29a0faa83b9
PYTHON_U_MSGPACK_SETUP_TYPE = setuptools
PYTHON_U_MSGPACK_LICENSE = MIT
PYTHON_U_MSGPACK_LICENSE_FILES = LICENSE

$(eval $(python-package))
