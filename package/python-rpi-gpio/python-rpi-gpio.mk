################################################################################
#
# python-rpi-gpio
#
################################################################################

PYTHON_RPI_GPIO_VERSION = 0.6.3
PYTHON_RPI_GPIO_SOURCE = RPi.GPIO-$(PYTHON_RPI_GPIO_VERSION).tar.gz
PYTHON_RPI_GPIO_SITE = https://pypi.python.org/packages/e2/58/6e1b775606da6439fa3fd1550e7f714ac62aa75e162eed29dbec684ecb3e
PYTHON_RPI_GPIO_LICENSE = MIT
PYTHON_RPI_GPIO_LICENSE_FILES = LICENCE.txt
PYTHON_RPI_GPIO_SETUP_TYPE = distutils

$(eval $(python-package))
