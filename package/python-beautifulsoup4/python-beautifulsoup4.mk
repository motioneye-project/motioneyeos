################################################################################
#
# python-beautifulsoup4
#
################################################################################

PYTHON_BEAUTIFULSOUP4_VERSION = 4.5.3
PYTHON_BEAUTIFULSOUP4_SOURCE = beautifulsoup4-$(PYTHON_BEAUTIFULSOUP4_VERSION).tar.gz
PYTHON_BEAUTIFULSOUP4_SITE = https://pypi.python.org/packages/9b/a5/c6fa2d08e6c671103f9508816588e0fb9cec40444e8e72993f3d4c325936
PYTHON_BEAUTIFULSOUP4_SETUP_TYPE = setuptools
PYTHON_BEAUTIFULSOUP4_LICENSE = MIT
PYTHON_BEAUTIFULSOUP4_LICENSE_FILES = COPYING.txt

$(eval $(python-package))
