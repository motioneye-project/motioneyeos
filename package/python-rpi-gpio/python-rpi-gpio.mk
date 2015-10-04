################################################################################
#
# python-rpi-gpio
#
################################################################################

PYTHON_RPI_GPIO_VERSION = 0.5.11
PYTHON_RPI_GPIO_SOURCE = RPi.GPIO-$(PYTHON_RPI_GPIO_VERSION).tar.gz
PYTHON_RPI_GPIO_SITE = http://pypi.python.org/packages/source/R/RPi.GPIO
PYTHON_RPI_GPIO_SETUP_TYPE = distutils

$(eval $(python-package))

