################################################################################
#
# python-hpack
#
################################################################################

PYTHON_HPACK_VERSION = 3.0.0
PYTHON_HPACK_SOURCE = hpack-$(PYTHON_HPACK_VERSION).tar.gz
PYTHON_HPACK_SITE = https://pypi.python.org/packages/44/f1/b4440e46e265a29c0cb7b09b6daec6edf93c79eae713cfed93fbbf8716c5
PYTHON_HPACK_SETUP_TYPE = setuptools
PYTHON_HPACK_LICENSE = MIT
PYTHON_HPACK_LICENSE_FILES = LICENSE

$(eval $(python-package))
