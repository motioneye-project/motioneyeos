################################################################################
#
# python-rpi-ws281x
#
################################################################################

PYTHON_RPI_WS281X_VERSION = 4.2.2
PYTHON_RPI_WS281X_SOURCE = rpi_ws281x-$(PYTHON_RPI_WS281X_VERSION).tar.gz
PYTHON_RPI_WS281X_SITE = https://files.pythonhosted.org/packages/3b/b3/cdc84887ead3f15b9f3f2b5fe2b48168757a606c6d08feb53536a8afb396
PYTHON_RPI_WS281X_SETUP_TYPE = setuptools
PYTHON_RPI_WS281X_LICENSE = MIT
PYTHON_RPI_WS281X_LICENSE_FILES = LICENSE lib/LICENSE

$(eval $(python-package))
