################################################################################
#
# python-colibris
#
################################################################################

PYTHON_COLIBRIS_VERSION = 0.4.2
PYTHON_COLIBRIS_SOURCE = colibris-$(PYTHON_COLIBRIS_VERSION).tar.gz
PYTHON_COLIBRIS_SITE = https://files.pythonhosted.org/packages/05/88/2fcf6ddd6c9591147b14f691b9bf4007cc909a0f2f2e9fa8af5150a8e59d
PYTHON_COLIBRIS_SETUP_TYPE = setuptools
PYTHON_COLIBRIS_LICENSE = Apache-2.0
PYTHON_COLIBRIS_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
