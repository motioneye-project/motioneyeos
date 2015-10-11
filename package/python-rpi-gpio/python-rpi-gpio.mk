################################################################################
#
# python-rpi-gpio
#
################################################################################

PYTHON_RPI_GPIO_VERSION = 0.5.11
PYTHON_RPI_GPIO_SOURCE = RPi.GPIO-$(PYTHON_RPI_GPIO_VERSION).tar.gz
PYTHON_RPI_GPIO_SITE = http://pypi.python.org/packages/source/R/RPi.GPIO
PYTHON_RPI_GPIO_SETUP_TYPE = distutils

BOARD = $(shell basename $(BASE_DIR))
PYTHON_RPI_GPIO_PKG_DIR = $(TOPDIR)/package/python-rpi-gpio

define RPI2_BASE_ADDRESS_PATCH
    cd $(@D) && patch -p1 < $(PYTHON_RPI_GPIO_PKG_DIR)/bcm2836-base-address._patch
endef

ifeq ($(BOARD), raspberrypi2)
    PYTHON_RPI_GPIO_POST_PATCH_HOOKS += RPI2_BASE_ADDRESS_PATCH
endif

$(eval $(python-package))

