################################################################################
#
# python-idna
#
################################################################################

PYTHON_IDNA_VERSION = 2.0
PYTHON_IDNA_SOURCE = idna-$(PYTHON_IDNA_VERSION).tar.gz
PYTHON_IDNA_SITE = https://pypi.python.org/packages/source/i/idna
PYTHON_IDNA_LICENSE =  BSD-3c
PYTHON_IDNA_LICENSE_FILES = LICENSE.rst
PYTHON_IDNA_SETUP_TYPE = setuptools

$(eval $(python-package))
