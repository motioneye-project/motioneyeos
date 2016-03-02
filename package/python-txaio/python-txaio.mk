################################################################################
#
# python-txaio
#
################################################################################

PYTHON_TXAIO_VERSION = 2.2.1
PYTHON_TXAIO_SOURCE = txaio-$(PYTHON_TXAIO_VERSION).tar.gz
PYTHON_TXAIO_SITE = http://pypi.python.org/packages/source/t/txaio
PYTHON_TXAIO_LICENSE = MIT
PYTHON_TXAIO_LICENSE_FILES = LICENSE
PYTHON_TXAIO_SETUP_TYPE = setuptools

$(eval $(python-package))
