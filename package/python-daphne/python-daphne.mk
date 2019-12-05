################################################################################
#
# python-daphne
#
################################################################################

PYTHON_DAPHNE_VERSION = 2.4.0
PYTHON_DAPHNE_SOURCE = daphne-$(PYTHON_DAPHNE_VERSION).tar.gz
PYTHON_DAPHNE_SITE = https://files.pythonhosted.org/packages/c6/66/05ace288000d323831a9fab1e68a5625b117b7c8aca408404d33330f3906
PYTHON_DAPHNE_SETUP_TYPE = setuptools
# https://github.com/django/daphne/blob/master/LICENSE
PYTHON_DAPHNE_LICENSE = BSD-3-Clause
PYTHON_DAPHNE_LICENSE_FILES = PKG-INFO

$(eval $(python-package))
