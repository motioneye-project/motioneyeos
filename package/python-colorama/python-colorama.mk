################################################################################
#
# python-colorama
#
################################################################################

PYTHON_COLORAMA_VERSION = 0.4.3
PYTHON_COLORAMA_SOURCE = colorama-$(PYTHON_COLORAMA_VERSION).tar.gz
PYTHON_COLORAMA_SITE = https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d
PYTHON_COLORAMA_SETUP_TYPE = setuptools
PYTHON_COLORAMA_LICENSE = BSD-3-Clause
PYTHON_COLORAMA_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
