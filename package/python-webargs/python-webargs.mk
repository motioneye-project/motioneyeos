################################################################################
#
# python-webargs
#
################################################################################

PYTHON_WEBARGS_VERSION = 5.1.0
PYTHON_WEBARGS_SOURCE = webargs-$(PYTHON_WEBARGS_VERSION).tar.gz
PYTHON_WEBARGS_SITE = https://files.pythonhosted.org/packages/16/7b/68fded416d638bf1e5f41b28a49f045c0ef2abe344c7280d5e923e6cea1d
PYTHON_WEBARGS_SETUP_TYPE = setuptools
PYTHON_WEBARGS_LICENSE = Apache-2.0
PYTHON_WEBARGS_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
