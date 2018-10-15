################################################################################
#
# python-babel
#
################################################################################

PYTHON_BABEL_VERSION = 2.6.0
PYTHON_BABEL_SOURCE = Babel-$(PYTHON_BABEL_VERSION).tar.gz
PYTHON_BABEL_SITE = https://files.pythonhosted.org/packages/be/cc/9c981b249a455fa0c76338966325fc70b7265521bad641bf2932f77712f4
PYTHON_BABEL_SETUP_TYPE = setuptools
PYTHON_BABEL_LICENSE = BSD-3-Clause
PYTHON_BABEL_LICENSE_FILES = LICENSE

$(eval $(python-package))
