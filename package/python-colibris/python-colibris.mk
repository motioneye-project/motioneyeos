################################################################################
#
# python-colibris
#
################################################################################

PYTHON_COLIBRIS_VERSION = 0.6.1
PYTHON_COLIBRIS_SOURCE = colibris-$(PYTHON_COLIBRIS_VERSION).tar.gz
PYTHON_COLIBRIS_SITE = https://files.pythonhosted.org/packages/61/de/6f76814c12202cceda63d0db0cdc0ada2aede33526023a00ce14f6e5ea6e
PYTHON_COLIBRIS_SETUP_TYPE = setuptools
PYTHON_COLIBRIS_LICENSE = Apache-2.0
PYTHON_COLIBRIS_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
