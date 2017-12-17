################################################################################
#
# python-babel
#
################################################################################

PYTHON_BABEL_VERSION = 2.3.4
PYTHON_BABEL_SOURCE = Babel-$(PYTHON_BABEL_VERSION).tar.gz
PYTHON_BABEL_SITE = https://pypi.python.org/packages/6e/96/ba2a2462ed25ca0e651fb7b66e7080f5315f91425a07ea5b34d7c870c114
PYTHON_BABEL_SETUP_TYPE = setuptools
PYTHON_BABEL_LICENSE = BSD-3c
PYTHON_BABEL_LICENSE_FILES = LICENSE

$(eval $(python-package))
