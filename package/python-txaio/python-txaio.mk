################################################################################
#
# python-txaio
#
################################################################################

PYTHON_TXAIO_VERSION = 18.8.1
PYTHON_TXAIO_SOURCE = txaio-$(PYTHON_TXAIO_VERSION).tar.gz
PYTHON_TXAIO_SITE = https://files.pythonhosted.org/packages/c1/99/81de004578e9afe017bb1d4c8968088a33621c05449fe330bdd7016d5377
PYTHON_TXAIO_LICENSE = MIT
PYTHON_TXAIO_LICENSE_FILES = LICENSE
PYTHON_TXAIO_SETUP_TYPE = setuptools

$(eval $(python-package))
