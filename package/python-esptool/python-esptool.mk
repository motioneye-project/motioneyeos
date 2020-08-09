################################################################################
#
# python-esptool
#
################################################################################

PYTHON_ESPTOOL_VERSION = 2.8
PYTHON_ESPTOOL_SOURCE = esptool-$(PYTHON_ESPTOOL_VERSION).tar.gz
PYTHON_ESPTOOL_SITE = https://files.pythonhosted.org/packages/68/91/08c182f66fa3f12a96e754ae8ec7762abb2d778429834638f5746f81977a
PYTHON_ESPTOOL_SETUP_TYPE = setuptools
PYTHON_ESPTOOL_LICENSE = GPL-2.0+
PYTHON_ESPTOOL_LICENSE_FILES = LICENSE

$(eval $(python-package))
