################################################################################
#
# python-spidev
#
################################################################################

PYTHON_SPIDEV_VERSION = 3.2
PYTHON_SPIDEV_SOURCE = spidev-$(PYTHON_SPIDEV_VERSION).tar.gz
PYTHON_SPIDEV_SITE = https://pypi.python.org/packages/36/83/73748b6e1819b57d8e1df8090200195cdae33aaa22a49a91ded16785eedd
PYTHON_SPIDEV_SETUP_TYPE = distutils
PYTHON_SPIDEV_LICENSE = GPL-2.0
PYTHON_SPIDEV_LICENSE_FILES = LICENSE.md

$(eval $(python-package))
