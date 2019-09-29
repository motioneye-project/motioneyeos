################################################################################
#
# python-idna
#
################################################################################

PYTHON_IDNA_VERSION = 2.8
PYTHON_IDNA_SOURCE = idna-$(PYTHON_IDNA_VERSION).tar.gz
PYTHON_IDNA_SITE = https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7
PYTHON_IDNA_LICENSE =  BSD-3-Clause
PYTHON_IDNA_LICENSE_FILES = LICENSE.rst
PYTHON_IDNA_SETUP_TYPE = setuptools

$(eval $(python-package))
