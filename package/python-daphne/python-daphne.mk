################################################################################
#
# python-daphne
#
################################################################################

PYTHON_DAPHNE_VERSION = 2.3.0
PYTHON_DAPHNE_SOURCE = daphne-$(PYTHON_DAPHNE_VERSION).tar.gz
PYTHON_DAPHNE_SITE = https://files.pythonhosted.org/packages/7b/f1/994f55248e27059e160f9d07bf5d325a9891b99daf1eb775a14110e91e5b
PYTHON_DAPHNE_SETUP_TYPE = setuptools
# https://github.com/django/daphne/blob/master/LICENSE
PYTHON_DAPHNE_LICENSE = BSD-3-Clause
PYTHON_DAPHNE_LICENSE_FILES = PKG-INFO

$(eval $(python-package))
