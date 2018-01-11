################################################################################
#
# python-txaio
#
################################################################################

PYTHON_TXAIO_VERSION = 2.8.2
PYTHON_TXAIO_SOURCE = txaio-$(PYTHON_TXAIO_VERSION).tar.gz
PYTHON_TXAIO_SITE = https://pypi.python.org/packages/d6/95/d0c67304515f352342bc8fd14e5a3e7ca924134608acb730916073b18464
PYTHON_TXAIO_LICENSE = MIT
PYTHON_TXAIO_LICENSE_FILES = LICENSE
PYTHON_TXAIO_SETUP_TYPE = setuptools

$(eval $(python-package))
