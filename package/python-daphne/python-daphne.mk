################################################################################
#
# python-daphne
#
################################################################################

PYTHON_DAPHNE_VERSION = 2.4.1
PYTHON_DAPHNE_SOURCE = daphne-$(PYTHON_DAPHNE_VERSION).tar.gz
PYTHON_DAPHNE_SITE = https://files.pythonhosted.org/packages/03/6c/847d1c962f8c45aa2ab0791583c4a41669d158e28fd6369ce940b8ea8417
PYTHON_DAPHNE_SETUP_TYPE = setuptools
# https://github.com/django/daphne/blob/master/LICENSE
PYTHON_DAPHNE_LICENSE = BSD-3-Clause
PYTHON_DAPHNE_LICENSE_FILES = LICENSE

$(eval $(python-package))
