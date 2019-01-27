################################################################################
#
# python-colibris
#
################################################################################

PYTHON_COLIBRIS_VERSION = 0.4.3
PYTHON_COLIBRIS_SOURCE = colibris-$(PYTHON_COLIBRIS_VERSION).tar.gz
PYTHON_COLIBRIS_SITE = https://files.pythonhosted.org/packages/b7/ff/df9dd2a27f33f1d6003037f0597c4652dca50525f67f44f182ecc49c2baf
PYTHON_COLIBRIS_SETUP_TYPE = setuptools
PYTHON_COLIBRIS_LICENSE = Apache-2.0
PYTHON_COLIBRIS_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
