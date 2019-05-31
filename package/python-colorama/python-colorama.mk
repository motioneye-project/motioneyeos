################################################################################
#
# python-colorama
#
################################################################################

PYTHON_COLORAMA_VERSION = 0.4.1
PYTHON_COLORAMA_SOURCE = colorama-$(PYTHON_COLORAMA_VERSION).tar.gz
PYTHON_COLORAMA_SITE = https://files.pythonhosted.org/packages/76/53/e785891dce0e2f2b9f4b4ff5bc6062a53332ed28833c7afede841f46a5db
PYTHON_COLORAMA_SETUP_TYPE = setuptools
PYTHON_COLORAMA_LICENSE = BSD-3-Clause
PYTHON_COLORAMA_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
