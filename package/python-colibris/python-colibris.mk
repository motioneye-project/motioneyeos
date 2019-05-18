################################################################################
#
# python-colibris
#
################################################################################

PYTHON_COLIBRIS_VERSION = 0.6.2
PYTHON_COLIBRIS_SOURCE = colibris-$(PYTHON_COLIBRIS_VERSION).tar.gz
PYTHON_COLIBRIS_SITE = https://files.pythonhosted.org/packages/f6/39/9257111da84ba61f451addc84a03b07b967c398c5eef85b739849ebaccb0
PYTHON_COLIBRIS_SETUP_TYPE = setuptools
PYTHON_COLIBRIS_LICENSE = Apache-2.0
PYTHON_COLIBRIS_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
