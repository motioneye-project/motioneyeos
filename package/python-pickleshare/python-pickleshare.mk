################################################################################
#
# python-pickleshare
#
################################################################################

PYTHON_PICKLESHARE_VERSION = 0.7.5
PYTHON_PICKLESHARE_SOURCE = pickleshare-$(PYTHON_PICKLESHARE_VERSION).tar.gz
PYTHON_PICKLESHARE_SITE = https://files.pythonhosted.org/packages/d8/b6/df3c1c9b616e9c0edbc4fbab6ddd09df9535849c64ba51fcb6531c32d4d8
PYTHON_PICKLESHARE_LICENSE = MIT
PYTHON_PICKLESHARE_LICENSE_FILES = LICENSE
PYTHON_PICKLESHARE_SETUP_TYPE = setuptools

$(eval $(python-package))
