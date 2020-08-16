################################################################################
#
# python-wtforms
#
################################################################################

PYTHON_WTFORMS_VERSION = 2.3.1
PYTHON_WTFORMS_SOURCE = WTForms-$(PYTHON_WTFORMS_VERSION).tar.gz
PYTHON_WTFORMS_SITE = https://files.pythonhosted.org/packages/68/7a/4ce1636e03a25585f3e1436179232a66c25e53ef17f01b4384d16ace6d61
PYTHON_WTFORMS_SETUP_TYPE = setuptools
PYTHON_WTFORMS_LICENSE = BSD-3-Clause
PYTHON_WTFORMS_LICENSE_FILES = LICENSE.rst

$(eval $(python-package))
