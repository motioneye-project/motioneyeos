################################################################################
#
# python-gitdb2
#
################################################################################

PYTHON_GITDB2_VERSION = 2.0.6
PYTHON_GITDB2_SOURCE = gitdb2-$(PYTHON_GITDB2_VERSION).tar.gz
PYTHON_GITDB2_SITE = https://files.pythonhosted.org/packages/c5/62/ed7205331e8d7cc377e2512cb32f8f8f075c0defce767551d0a76e102ce2
PYTHON_GITDB2_SETUP_TYPE = setuptools
PYTHON_GITDB2_LICENSE = BSD-3-Clause
PYTHON_GITDB2_LICENSE_FILES = LICENSE

$(eval $(python-package))
