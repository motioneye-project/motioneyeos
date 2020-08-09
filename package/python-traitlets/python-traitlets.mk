################################################################################
#
# python-traitlets
#
################################################################################

PYTHON_TRAITLETS_VERSION = 4.3.3
PYTHON_TRAITLETS_SOURCE = traitlets-$(PYTHON_TRAITLETS_VERSION).tar.gz
PYTHON_TRAITLETS_SITE = https://files.pythonhosted.org/packages/75/b0/43deb021bc943f18f07cbe3dac1d681626a48997b7ffa1e7fb14ef922b21
PYTHON_TRAITLETS_LICENSE = BSD-3-Clause
PYTHON_TRAITLETS_LICENSE_FILES = COPYING.md
PYTHON_TRAITLETS_SETUP_TYPE = distutils

$(eval $(python-package))
