################################################################################
#
# python-u-msgpack
#
################################################################################

PYTHON_U_MSGPACK_VERSION = 2.5.0
PYTHON_U_MSGPACK_SOURCE = u-msgpack-python-$(PYTHON_U_MSGPACK_VERSION).tar.gz
PYTHON_U_MSGPACK_SITE = https://files.pythonhosted.org/packages/f5/97/36d5ac7d71451e282051e48219cc825637f617a8f620a2edf90ab61b7f97
PYTHON_U_MSGPACK_SETUP_TYPE = setuptools
PYTHON_U_MSGPACK_LICENSE = MIT
PYTHON_U_MSGPACK_LICENSE_FILES = LICENSE

$(eval $(python-package))
