################################################################################
#
# python-rpi-gpio
#
################################################################################

PYTHON_RPI_GPIO_VERSION = 0.6.2
PYTHON_RPI_GPIO_SOURCE = RPi.GPIO-$(PYTHON_RPI_GPIO_VERSION).tar.gz
PYTHON_RPI_GPIO_SITE = https://pypi.python.org/packages/c1/a8/de92cf6d04376f541ce250de420f4fe7cbb2b32a7128929a600bc89aede5
PYTHON_RPI_GPIO_LICENSE = MIT
PYTHON_RPI_GPIO_LICENSE_FILES = LICENCE.txt
PYTHON_RPI_GPIO_SETUP_TYPE = distutils

$(eval $(python-package))
