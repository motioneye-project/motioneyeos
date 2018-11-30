################################################################################
#
# python-msgpack
#
################################################################################

PYTHON_MSGPACK_VERSION = 0.6.0
PYTHON_MSGPACK_SOURCE = msgpack-$(PYTHON_MSGPACK_VERSION).tar.gz
PYTHON_MSGPACK_SITE = https://files.pythonhosted.org/packages/3a/bb/dc3f9fc608a6c1c7a471c2bebc761d9c8dbb2f7179a4283a89b9451765b5
PYTHON_MSGPACK_LICENSE = Apache-2.0
PYTHON_MSGPACK_LICENSE_FILES = COPYING
PYTHON_MSGPACK_SETUP_TYPE = setuptools

$(eval $(python-package))
