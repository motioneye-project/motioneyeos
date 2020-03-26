################################################################################
#
# python-txaio
#
################################################################################

PYTHON_TXAIO_VERSION = 20.3.1
PYTHON_TXAIO_SOURCE = txaio-$(PYTHON_TXAIO_VERSION).tar.gz
PYTHON_TXAIO_SITE = https://files.pythonhosted.org/packages/ca/a0/f19a421547b60fbd7ccb48b56c51deac56bffec9b256f9bd7c622572d0a8
PYTHON_TXAIO_LICENSE = MIT
PYTHON_TXAIO_LICENSE_FILES = LICENSE
PYTHON_TXAIO_SETUP_TYPE = setuptools

$(eval $(python-package))
