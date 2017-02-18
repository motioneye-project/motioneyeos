################################################################################
#
# python-rpi-gpio
#
################################################################################

PYTHON_RPI_GPIO_VERSION = 0.6.1
PYTHON_RPI_GPIO_SOURCE = RPi.GPIO-$(PYTHON_RPI_GPIO_VERSION).tar.gz
PYTHON_RPI_GPIO_SITE = http://sourceforge.net/projects/raspberry-gpio-python/files
PYTHON_RPI_GPIO_LICENSE = MIT
PYTHON_RPI_GPIO_LICENSE_FILES = LICENCE.txt
PYTHON_RPI_GPIO_SETUP_TYPE = distutils

$(eval $(python-package))
