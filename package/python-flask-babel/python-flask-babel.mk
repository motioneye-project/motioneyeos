################################################################################
#
# python-flask-babel
#
################################################################################

PYTHON_FLASK_BABEL_VERSION = 0.12.2
PYTHON_FLASK_BABEL_SOURCE = Flask-Babel-$(PYTHON_FLASK_BABEL_VERSION).tar.gz
PYTHON_FLASK_BABEL_SITE = https://files.pythonhosted.org/packages/82/b0/986b29938d4e8be7deb552ebfd1ef16c311276a59bcae10dec567a5b3d20
PYTHON_FLASK_BABEL_LICENSE = BSD-3-Clause
PYTHON_FLASK_BABEL_SETUP_TYPE = setuptools
PYTHON_FLASK_BABEL_LICENSE_FILES = LICENSE

$(eval $(python-package))
