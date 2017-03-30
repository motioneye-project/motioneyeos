################################################################################
#
# python-idna
#
################################################################################

PYTHON_IDNA_VERSION = 2.2
PYTHON_IDNA_SOURCE = idna-$(PYTHON_IDNA_VERSION).tar.gz
PYTHON_IDNA_SITE = https://pypi.python.org/packages/94/fe/efb1cb6f505e1a560b3d080ae6b9fddc11e7c542d694ce4635c49b1ccdcb
PYTHON_IDNA_LICENSE =  BSD-3-Clause
PYTHON_IDNA_LICENSE_FILES = LICENSE.rst
PYTHON_IDNA_SETUP_TYPE = setuptools

$(eval $(python-package))
