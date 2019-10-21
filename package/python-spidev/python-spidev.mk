################################################################################
#
# python-spidev
#
################################################################################

PYTHON_SPIDEV_VERSION = 3.4
PYTHON_SPIDEV_SOURCE = spidev-$(PYTHON_SPIDEV_VERSION).tar.gz
PYTHON_SPIDEV_SITE = https://files.pythonhosted.org/packages/fb/14/4c2e1640f0cb04862c76d9d76ed7c945b0f67876e503ac02f7f675fe86a0
PYTHON_SPIDEV_SETUP_TYPE = distutils
PYTHON_SPIDEV_LICENSE = MIT
PYTHON_SPIDEV_LICENSE_FILES = README.md

$(eval $(python-package))
