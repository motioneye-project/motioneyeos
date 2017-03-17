################################################################################
#
# python-html5lib
#
################################################################################

PYTHON_HTML5LIB_VERSION = 1.0b10
PYTHON_HTML5LIB_SOURCE = html5lib-$(PYTHON_HTML5LIB_VERSION).tar.gz
PYTHON_HTML5LIB_SITE = https://pypi.python.org/packages/97/16/982214624095c1420c75f3bd295d9e658794aafb95fc075823de107e0ae4
PYTHON_HTML5LIB_LICENSE = MIT
PYTHON_HTML5LIB_LICENSE_FILES = LICENSE
PYTHON_HTML5LIB_SETUP_TYPE = setuptools

$(eval $(python-package))
