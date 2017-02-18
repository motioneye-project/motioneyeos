################################################################################
#
# python-txaio
#
################################################################################

PYTHON_TXAIO_VERSION = 2.5.1
PYTHON_TXAIO_SOURCE = txaio-$(PYTHON_TXAIO_VERSION).tar.gz
PYTHON_TXAIO_SITE = https://pypi.python.org/packages/45/e1/f7d88767d65dbfc20d4b4aa0dad657dbbe8ca629ead2bef24da04630a12a
PYTHON_TXAIO_LICENSE = MIT
PYTHON_TXAIO_LICENSE_FILES = LICENSE
PYTHON_TXAIO_SETUP_TYPE = setuptools

$(eval $(python-package))
