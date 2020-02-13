################################################################################
#
# python-txaio
#
################################################################################

PYTHON_TXAIO_VERSION = 20.1.1
PYTHON_TXAIO_SOURCE = txaio-$(PYTHON_TXAIO_VERSION).tar.gz
PYTHON_TXAIO_SITE = https://files.pythonhosted.org/packages/50/ea/dd4c34ade00ddfcd2f32b4f1e7136a50ae13894009d64024a9d03f8c594f
PYTHON_TXAIO_LICENSE = MIT
PYTHON_TXAIO_LICENSE_FILES = LICENSE
PYTHON_TXAIO_SETUP_TYPE = setuptools

$(eval $(python-package))
