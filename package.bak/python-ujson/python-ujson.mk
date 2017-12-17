################################################################################
#
# python-ujson
#
################################################################################

PYTHON_UJSON_VERSION = 1.35
PYTHON_UJSON_SOURCE = ujson-$(PYTHON_UJSON_VERSION).tar.gz
PYTHON_UJSON_SITE = http://pypi.python.org/packages/source/u/ujson
PYTHON_UJSON_LICENSE = BSD-3c
PYTHON_UJSON_SETUP_TYPE = setuptools

$(eval $(python-package))
