################################################################################
#
# python-dominate
#
################################################################################

PYTHON_DOMINATE_VERSION = 2.4.0
PYTHON_DOMINATE_SOURCE = dominate-$(PYTHON_DOMINATE_VERSION).tar.gz
PYTHON_DOMINATE_SITE = https://files.pythonhosted.org/packages/46/dd/0fde17069c908951941475eee110c84467591caa1cd8ca30136294c26621
PYTHON_DOMINATE_SETUP_TYPE = setuptools
PYTHON_DOMINATE_LICENSE = LGPL-3.0+
PYTHON_DOMINATE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
