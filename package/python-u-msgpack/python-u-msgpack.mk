################################################################################
#
# python-u-msgpack
#
################################################################################

PYTHON_U_MSGPACK_VERSION = 2.1
PYTHON_U_MSGPACK_SOURCE = u-msgpack-python-$(PYTHON_U_MSGPACK_VERSION).tar.gz
PYTHON_U_MSGPACK_SITE = https://pypi.python.org/packages/b7/8d/791f037a0954f98a8eceb09c7c14babb97db0a81c985108bb21939b801eb
PYTHON_U_MSGPACK_SETUP_TYPE = distutils
PYTHON_U_MSGPACK_LICENSE = MIT
PYTHON_U_MSGPACK_LICENSE_FILES = umsgpack.py

$(eval $(python-package))
