################################################################################
#
# python-beautifulsoup4
#
################################################################################

PYTHON_BEAUTIFULSOUP4_VERSION = 4.4.1
PYTHON_BEAUTIFULSOUP4_SOURCE = beautifulsoup4-$(PYTHON_BEAUTIFULSOUP4_VERSION).tar.gz
PYTHON_BEAUTIFULSOUP4_SITE = https://pypi.python.org/packages/source/b/beautifulsoup4
PYTHON_BEAUTIFULSOUP4_SETUP_TYPE = setuptools
PYTHON_BEAUTIFULSOUP4_LICENSE = MIT
PYTHON_BEAUTIFULSOUP4_LICENSE_FILES = COPYING.txt

$(eval $(python-package))
