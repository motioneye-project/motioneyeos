################################################################################
#
# python-msgpack
#
################################################################################

PYTHON_MSGPACK_VERSION = 0.4.0
PYTHON_MSGPACK_SOURCE = msgpack-python-$(PYTHON_MSGPACK_VERSION).tar.gz
PYTHON_MSGPACK_SITE = https://pypi.python.org/packages/source/m/msgpack-python/
PYTHON_MSGPACK_LICENSE = Apache-2.0
PYTHON_MSGPACK_LICENSE_FILES = COPYING
PYTHON_MSGPACK_SETUP_TYPE = setuptools
PYTHON_MSGPACK_DEPENDENCIES = msgpack

$(eval $(python-package))
