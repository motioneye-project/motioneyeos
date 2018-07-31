################################################################################
#
# python-idna
#
################################################################################

PYTHON_IDNA_VERSION = 2.7
PYTHON_IDNA_SOURCE = idna-$(PYTHON_IDNA_VERSION).tar.gz
PYTHON_IDNA_SITE = https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935
PYTHON_IDNA_LICENSE =  BSD-3-Clause
PYTHON_IDNA_LICENSE_FILES = LICENSE.rst
PYTHON_IDNA_SETUP_TYPE = setuptools

$(eval $(python-package))
