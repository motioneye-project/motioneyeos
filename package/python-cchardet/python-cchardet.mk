################################################################################
#
# python-cchardet
#
################################################################################

PYTHON_CCHARDET_VERSION = 2.1.5
PYTHON_CCHARDET_SOURCE = cchardet-$(PYTHON_CCHARDET_VERSION).tar.gz
PYTHON_CCHARDET_SITE = https://files.pythonhosted.org/packages/73/25/73649708a30aa97124631bd088a22f1bf721d05d4e72fb9cc9bedb97de51
PYTHON_CCHARDET_SETUP_TYPE = setuptools
PYTHON_CCHARDET_LICENSE = MPL-1.1
PYTHON_CCHARDET_LICENSE_FILES = COPYING

$(eval $(python-package))
