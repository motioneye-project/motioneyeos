################################################################################
#
# python-beautifulsoup4
#
################################################################################

PYTHON_BEAUTIFULSOUP4_VERSION = 4.5.1
PYTHON_BEAUTIFULSOUP4_SOURCE = beautifulsoup4-$(PYTHON_BEAUTIFULSOUP4_VERSION).tar.gz
PYTHON_BEAUTIFULSOUP4_SITE = https://pypi.python.org/packages/86/ea/8e9fbce5c8405b9614f1fd304f7109d9169a3516a493ce4f7f77c39435b7
PYTHON_BEAUTIFULSOUP4_SETUP_TYPE = setuptools
PYTHON_BEAUTIFULSOUP4_LICENSE = MIT
PYTHON_BEAUTIFULSOUP4_LICENSE_FILES = COPYING.txt

$(eval $(python-package))
