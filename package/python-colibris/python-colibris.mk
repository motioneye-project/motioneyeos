################################################################################
#
# python-colibris
#
################################################################################

PYTHON_COLIBRIS_VERSION = 0.4.4
PYTHON_COLIBRIS_SOURCE = colibris-$(PYTHON_COLIBRIS_VERSION).tar.gz
PYTHON_COLIBRIS_SITE = https://files.pythonhosted.org/packages/95/87/0d4611a947ae77c3412b152040e99bec1a760864e76acee0028b50c9baa8
PYTHON_COLIBRIS_SETUP_TYPE = setuptools
PYTHON_COLIBRIS_LICENSE = Apache-2.0
PYTHON_COLIBRIS_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
