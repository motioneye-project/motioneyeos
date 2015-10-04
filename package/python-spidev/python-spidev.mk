################################################################################
#
# python-spidev
#
################################################################################

PYTHON_SPIDEV_VERSION = 3.0
PYTHON_SPIDEV_SOURCE = spidev-$(PYTHON_SPIDEV_VERSION).tar.gz
PYTHON_SPIDEV_SITE = https://pypi.python.org/packages/source/s/spidev
PYTHON_SPIDEV_SETUP_TYPE = distutils
PYTHON_SPIDEV_LICENSE = GPLv2
PYTHON_SPIDEV_LICENSE_FILES = LICENSE.md

$(eval $(python-package))
